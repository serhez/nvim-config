# Neovim editing-lag investigation

Date: 2026-08-28

## Executive summary

The investigation isolated two dominant motion-time costs:

1. `vim-matchup` synchronously searched for matching delimiters on every
   `CursorMoved` event. Depending on the file, deferring or disabling its
   matchparen work reduced held-`j` latency by roughly 52–72%.
2. `vim-wordmotion` replaced native `w` with a regex-heavy subword motion.
   Native `w` and deferred matchup together reduced the measured 300-`w`
   backlog from about 3.4 seconds to about 0.22 seconds (roughly 94%).

Secondary contributors are cumulative cursor-movement refresh hooks,
sign-density-sensitive `statuscol.nvim` work, Treesitter and renderer work in
large Markdown buffers, and LSP request churn from `vim-illuminate` in buffers
whose language server supports document highlights.

The investigation also reproduced a separate catastrophic startup failure: on
a fresh Neovim state directory, enabling `vim.loader` before lazy.nvim has
created `lazy/pkg-cache.lua` can enter recursive plugin-spec imports, consume
one CPU core, and grow memory without bound. This matches the observed class of
Neovim processes reaching 100% CPU and tens of gigabytes of RAM.

## Scope and methodology

This was an editing-latency investigation, not a startup-time benchmark.

The probe:

- launched the real configuration in a disposable embedded Neovim;
- attached a 120x45 line-grid UI so normal redraw paths ran;
- opened real files and allowed lazy plugins and LSP clients to attach;
- sent actual mapped keys through `nvim_input()` one at a time;
- waited for nested scheduled callbacks so queued work was included;
- changed plugin globals, mappings, autocmds, and options only inside the child
  process;
- repeated isolation scenarios and forcibly cleaned up children;
- did not write test changes into the configuration.

Representative fixtures:

- a 694-line Lua configuration file;
- an 82 KB, 2,467-line Markdown document;
- a 990 KB, 6,612-line Markdown document with lines up to 1,149 bytes;
- a synthetic 1,000-diagnostic/sign scenario;
- a 3,060-line Rust file for LSP capability inspection.

The full configuration loaded roughly 80 plugins after `VeryLazy` and the
first cursor movement. More than ten `CursorMoved` callbacks were present,
including matchup, dropbar, lualine, blink, render-latex, render-markdown,
Bento, treesitter-context, Snacks scope, and illuminate.

Early absolute timings were collected while an accidental runaway diagnostic
process was consuming another core. This can inflate raw milliseconds. The
paired isolation deltas repeated consistently, and guarded post-cooldown tests
reproduced the key deferred-matchup/native-word result. Rankings and relative
effects are therefore more trustworthy than absolute timing values.

The embedded UI cannot reproduce terminal graphics, tmux escape-sequence
latency, or physical key-repeat timing exactly. mdmath/render-latex image costs
and dynamic terminal-title output remain partially conditional for that reason.

## Benchmark results

| Fixture and motion | Full configuration | Isolation | Effect |
| --- | ---: | ---: | ---: |
| Lua, 100 x `j` | about 611–615 ms | matchup deferred/off: about 219–249 ms | about 60–64% faster |
| Lua, 300 x `w` | about 3,395 ms | native `w`: about 1,718 ms | about 49% faster |
| Lua, 300 x `w` | about 3,395 ms | deferred matchup: about 2,307 ms | about 32% faster |
| Lua, 300 x `w` | about 3,395 ms | deferred matchup + native `w`: about 217 ms | about 94% faster |
| Markdown, 2,467 lines, 60 x `j` | about 309–359 ms | matchup off: about 148–156 ms | about 52–56% faster |
| Markdown, 6,612 lines, 60 x `j` | about 663 ms | matchup off: about 187 ms | about 72% faster |
| 1,000 diagnostics/signs, 100 x `j` | about 318 ms | statuscolumn off: about 206 ms | about 35% faster |
| Large Markdown after matchup removal | about 159 ms | renderers + TS highlight off: about 118 ms | about 26% faster |

A clean Neovim required roughly 0.09 ms per `j` in the same UI harness. The
remaining full-config cost after removing matchup was therefore real, but much
smaller and distributed across several features.

When input was paced at 10 ms per key rather than sent as a burst, synchronous
matchup work often fit between key events and did not build a visible queue.
Periodic hooks still consumed about 0.4–1.1 ms per key in aggregate. This
explains why lag is particularly obvious under key-repeat: once the per-key
work exceeds the repeat interval, Neovim accumulates an input/redraw backlog.

## Ranked findings

### 1. vim-matchup: primary cost for all motions

The plugin was eagerly loaded and left
`g:matchup_matchparen_deferred` at its default `0`. Its `CursorMoved` callback
therefore called delimiter highlighting synchronously.

Relevant files:

- [`lua/plugins/configs/matchup.lua`](../lua/plugins/configs/matchup.lua)
- installed `autoload/matchup/matchparen.vim`, function
  `s:matchparen.highlight_deferred()`

Findings:

- deferred mode was nearly as fast as disabling matchparen entirely;
- reducing matchparen timeout to 30 ms did not materially help;
- reducing `matchup_matchparen_stopline` to 50 did not materially help;
- the configured Treesitter `stopline = 500` is a separate option and did not
  bound normal matchparen scanning;
- increasing deferred show delay from 50 to 200 ms did not improve throughput.

Applied decision: set `vim.g.matchup_matchparen_deferred = 1` in the plugin's
`init` callback and retain the default deferred delay.

### 2. vim-wordmotion: primary `w`-specific cost

`vim-wordmotion` loaded on `CursorMoved` and mapped `w` to
`<Plug>WordMotion_w`. Each invocation constructs subword/camel-case regular
expressions, calls `search()`, and opens folds with `normal! zv`.

Relevant file: [`lua/plugins/configs/wordmotion.lua`](../lua/plugins/configs/wordmotion.lua)

The wordmotion cost and matchup cost were independently additive. Native `w`
alone approximately halved the measured cost; combining native `w` with
deferred matchup removed about 94% of the original backlog.

Applied decision: keep the plugin specification but set `enabled = false`.

### 3. Cumulative movement refresh hooks

No secondary hook matched matchup by itself, but disabling the named movement
hooks after removing matchup saved another roughly 15–25%, depending on the
fixture.

- dropbar updates its cursor-dependent breadcrumb with a default 32 ms
  trailing debounce;
- lualine inherited `CursorMoved`/`CursorMovedI`, queued a refresh, and checked
  the queue every 16 ms even though the configured component timers were
  100 ms;
- treesitter-context is internally throttled to at most two updates every
  150 ms, but used cursor mode and unlimited `max_lines`;
- render-markdown schedules visible-mark anti-conceal work after movement;
- render-latex queues its renderer from a global cursor callback;
- Snacks scope, Bento, blink, and illuminate add smaller callbacks.

Applied lualine policy:

- remove `CursorMoved` and `CursorMovedI` from refresh events;
- update statusline/tabline/winbar on a one-second timer;
- retain prompt state-change events such as buffer, mode, diagnostic, and LSP
  attachment events;
- check queued state-change refreshes every 100 ms.

Further low-risk candidates, not yet applied:

1. Increase dropbar's `update_debounce` from 32 ms to around 75–100 ms.
2. Bound treesitter-context (`max_lines` around 3–5) and disable it above a
   line-count threshold.
3. Disable Markdown renderers or Treesitter context selectively above a
   line/byte threshold rather than globally.
4. Remove `%l` from `titlestring` if a real tmux/TUI test shows terminal-title
   output on every logical-line move.
5. Leave render-markdown's existing debounce intact; it was moderate rather
   than dominant.

### 4. statuscol.nvim: sign-density-sensitive, not an LSP/DAP/git caller

`statuscol.nvim` does not itself call LSP, DAP, or git on redraw. Those systems
place signs/extmarks asynchronously. Statuscol reads and formats the existing
sign state.

The plugin retrieves all sign extmarks for the buffer once per window per
redraw whenever sign segments are configured. With ordinary buffers containing
0–7 signs, its measured effect was negligible. With 1,000 signs, disabling the
statuscolumn improved motion by about 35%.

Relevant file: [`lua/plugins/configs/statuscol.lua`](../lua/plugins/configs/statuscol.lua)

There is no supported time-based cache option. Monkey-patching its redraw tick
would display stale diagnostics, breakpoints, and gitsigns and would depend on
plugin internals. No throttle was applied.

If pathological sign-heavy buffers are common, cleaner options are:

- use a simpler native `%s`/`%C` statuscolumn;
- switch to the native statuscolumn only above a sign/diagnostic threshold;
- accept stale signs through a local fork, which is the least desirable option.

### 5. Lualine diagnostic/git work

The custom diff provider reads `vim.b.gitsigns_status_dict`; it does not invoke
git. DAP functions in statuscol are click handlers and do not run on redraw.

The lualine diagnostics component used the `nvim_lsp` source, which walks all
diagnostics and filters namespaces. Neovim 0.12 provides cached counts through
`vim.diagnostic.count()`.

Applied decision:

- change the source to `nvim_diagnostic`;
- perform periodic component evaluation once per second instead of on every
  cursor movement.

This may include non-LSP diagnostics in the displayed counts, which is usually
desirable because linters share `vim.diagnostic`.

### 6. Large Markdown buffers

The 990 KB/6,612-line fixture was below the custom 2 MB big-file threshold, so
it still received Treesitter highlighting, treesitter-context, render-markdown,
render-latex/mdmath behavior, spell checking, dropbar Markdown parsing, and LSP
features.

After matchup was removed from the measurement:

- Treesitter highlighting contributed roughly another 10%;
- the Markdown rendering stack contributed roughly 15%;
- disabling both improved residual motion time by roughly 26%;
- spell checking had no meaningful measured effect.

The uncounted `j`/`k` mappings use `gj`/`gk`. On the fixture's longest wrapped
line, 30 `gj` presses advanced only about nine logical lines, while native `j`
advanced thirty. The mapping is not intrinsically expensive, but it multiplies
the number of cursor events and plugin callbacks needed to traverse prose.

The existing big-file policy should eventually gain a line-count threshold;
byte size alone misses structurally large documents.

### 7. mdmath, render-latex, and render-markdown ownership

The names obscure the actual behavior:

- `render-latex.nvim` is intentionally a Markdown display-equation renderer.
  It is not intended to render ordinary `.tex`/LaTeX source files. Its default
  supported filetype is `markdown` and its default maximum is 5,000 lines.
- `mdmath.nvim` is also an equation-image renderer whose documented default is
  Markdown. The local configuration extends it to Quarto, Rmd, and `latex`.
- `render-markdown.nvim` handles Markdown structure. Its own text-based LaTeX
  renderer is already disabled, which is correct when an image renderer owns
  equations.

The local history shows mdmath was disabled before commit `8c5de62`
(`feat(latex): render LaTeX in markdown via render-latex.nvim`). That commit
added render-latex, accidentally re-enabled mdmath, and left mdmath configured
through `M.setup()`, which lazy.nvim never invokes.

If both image renderers attach to Markdown they collide on display equations
and both add cursor/render work. Applied ownership:

- render-latex owns `markdown`;
- repaired mdmath owns `quarto`, `rmd`, and the existing `latex` filetype;
- mdmath auto-setup is disabled and its real lazy.nvim `config` callback calls
  `require("mdmath").setup()` exactly once.

If mdmath is preferred for Markdown, invert this later: add `markdown` back to
mdmath and disable render-latex. Do not attach both.

### 8. vim-illuminate provider behavior

The LSP provider calls `vim.lsp.buf_request_all()` before applying the display
delay. On every cursor movement it cancels the previous unfinished request and
sends another `textDocument/documentHighlight` request. A Rust capability probe
confirmed that `rust_analyzer` supports this method.

The configured Markdown clients in both tested documents did **not** support
document highlights, so those buffers were already falling back to the regex
provider and were not producing LSP request churn. The regex provider scans the
buffer after the cursor has remained still for the configured delay; repeated
movement resets that timer.

The plugin has no supported request-rate option. A true "at most one LSP
request per second" wrapper would need to coordinate private provider state,
cancel functions, stale references, and the engine's polling timer. That would
be update-fragile.

Applied decision:

- keep illuminate enabled;
- use only the supported regex provider, producing zero document-highlight LSP
  requests;
- retain a 250 ms quiet-period delay for normal buffers;
- use a 500 ms delay and hide the under-cursor occurrence above 2,000 lines.

Tradeoff: highlights are lexical (same word text) rather than LSP-semantic.

### 9. CursorHold and updatetime

`settings.lua` set `updatetime = 300`, but nvim-lightbulb overwrote it with
100 ms. That made several pause-time actions eligible after only 100 ms:

- lightbulb code-action requests;
- diagnostic float logic;
- LSP code-lens enabling.

These do not explain continuous held-key throughput, but can cause a stutter
when pausing and resuming.

Applied decision: set nvim-lightbulb's `updatetime = -1`, so it preserves the
global 300 ms value.

### 10. Lower-probability or ruled-out causes

- `neoscroll.nvim` does not map `j`, `k`, or `w`.
- Disabling cursorline did not measurably help.
- Disabling statuscolumn with ordinary sign counts did not help.
- Markdown spell checking was negligible.
- Native `j` versus `gj` made little difference on short code lines.
- Blink's normal-mode callbacks return quickly.
- Bento is small unless its menu is open.
- Dynamic title updates were negligible in the embedded UI, but remain a
  terminal/tmux-specific possibility because the title includes `%l`.
- Semantic tokens and code lens can add highlight/redraw work, but semantic
  tokens do not issue one request per cursor movement.

## Runaway 100%-CPU / unbounded-memory Neovim

### Reproduction

The failure was reproduced by starting the full configuration with a fresh
`XDG_STATE_HOME`. The new state had no `lazy/pkg-cache.lua`.

Sequence:

1. `vim.loader.enable()` ran on the first line of `init.lua`.
2. lazy.nvim tried to load the absent package-cache module/file.
3. `vim.loader` cached the negative lookup.
4. lazy.nvim generated and wrote `lazy/pkg-cache.lua`.
5. lazy.nvim recursively normalized/imported plugin specs.
6. the loader continued serving the cached miss, so the same 144 spec files
   were imported repeatedly.

Instrumentation caught the loop inside `vim.loader` and
`lazy.core.plugin.load/import/normalize`, with the spec tree already imported
multiple times. The process consumed approximately one core and grew from
hundreds of megabytes into multiple gigabytes; given enough time it can account
for the previously observed 30 GB processes.

With loader enablement suppressed, the identical fresh-state startup completed
in about 0.15 seconds.

### Fix

`vim.loader.enable()` is now called immediately **after**
`require("plugins").setup()`. lazy.nvim can create/load its package cache before
the Neovim loader begins caching module lookups, while later lazy-loaded modules
still benefit from the loader.

This is the highest-confidence explanation for the exact runaway signature
that was reproduced. Other unrelated plugin bugs can theoretically consume CPU,
so continued process monitoring is prudent, but the demonstrated recursion path
has been removed.

## Background process audit

The audit found 14 orphaned `vscode-neovim` processes with PPID 1, aged roughly
11–64 days. At one snapshot they collectively used about 490 MB RSS and 7% CPU.
They did not explain motion-specific `w`/`j` deltas, but they can worsen system
responsiveness. Long-lived embedded Neovims whose parents were tmux shells were
also present and appeared intentional.

No diagnostic harness or benchmark Neovim remained after the final process
audit.

## Applied changes

- defer vim-matchup matchparen work;
- disable, but retain, the vim-wordmotion plugin specification;
- move `vim.loader.enable()` until after lazy.nvim setup;
- repair mdmath's lazy.nvim callback and separate renderer ownership;
- remove illuminate's LSP provider and add a large-buffer quiet delay;
- restore effective `updatetime` to 300 ms;
- remove movement-triggered lualine refreshes, refresh periodically at one
  second, and use cached diagnostic counts;
- leave statuscol unchanged because it does not make external calls and a time
  cache would require stale display state/private internals.

## Post-change verification

Effective configuration assertions passed in a guarded headless instance:

- `g:matchup_matchparen_deferred == 1`;
- normal-mode `w` has no plugin mapping;
- `updatetime == 300`;
- lualine uses a one-second timer and its event list has no cursor movement;
- illuminate uses only regex, with the 2,000-line/500 ms large-file policy;
- mdmath is configured exactly once for Quarto, Rmd, and `latex` with its
  400 ms update interval.

The exact fresh-state failure condition was rerun with empty state and cache
directories. Startup completed successfully in about 0.36 seconds, exited with
status 0, and created `nvim/lazy/pkg-cache.lua`. It neither recursed nor grew
memory, confirming the loader-order fix for the reproduced runaway path.

Guarded motion checks after the changes:

| Fixture and motion | Before | After | Approximate improvement |
| --- | ---: | ---: | ---: |
| Lua, 100 x `j` | 611–615 ms | 278 ms | 55% |
| Lua, 150 x `w` | about 1,698 ms when scaled from the original 300-key run | 100 ms | 94% |
| Markdown, 6,612 lines, 60 x `j` | 663 ms | 188 ms | 72% |

The new Lua `w` result was about 0.67 ms per key. All guarded verification runs
reported macOS thermal state 0 (nominal).

## Follow-up evaluation

After living with the first change set, evaluate in this order:

1. Held `w`, `j`, and `k` in ordinary Lua/code buffers.
2. Wrapped navigation in 2,000–7,000-line Markdown buffers.
3. Whether lexical illuminate highlighting is sufficient without LSP semantic
   read/write distinctions.
4. Whether one-second lualine location/progress updates feel responsive enough.
5. Sign-heavy Trouble/diagnostic buffers for statuscolumn degradation.
6. Dropbar debounce and bounded treesitter-context only if residual lag remains.
7. A real tmux test with `%l` removed from `titlestring` if terminal-only lag
   persists.

## Security note unrelated to latency

A plaintext API credential was found in the ignored local environment module
and appeared in diagnostic output during inspection. Its value is intentionally
not recorded here. Rotate that credential and prefer the system keychain or a
process environment source rather than plaintext Lua.
