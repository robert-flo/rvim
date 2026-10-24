# 🏛️ rvim Architecture: The Complete Technical Guide

Reference manual detailing the architecture, execution lifecycle, dependency graph, internal mechanisms, and design decisions of `rvim`.

---

## 🎯 1. Architectural Philosophy

1. **Native Neovim 0.12+ (Zero Third-Party Manager Overhead)**:
   - Eliminates external managers like `lazy.nvim` or `packer`.
   - Relies on Neovim's native package manager (`vim.pack.add`) paired with `nvim-pack-lock.json` for deterministic revision locking.
   - Uses `vim.loader.enable()` for persistent bytecode compilation, achieving cold boot times under 5 ms.
2. **Decoupled 4-Tier Layer Architecture**:
   - The editor is structured into four distinct, independent layers.
   - The core configuration (Layer 1) has **zero plugin dependencies**—if plugins fail or are disabled, Neovim remains completely functional, responsive, and comfortable.
3. **Strict Namespace Encapsulation (`lua/rvim/`)**:
   - Every internal file lives under the `rvim/` subdirectory within Neovim's `runtimepath`. This eliminates naming collisions with external plugins.
4. **Upstream Parity & Minimal Diff**:
   - Code files mirror the upstream Craftzdog configuration 1:1, modifying only the `craftzdog` $\to$ `rvim` namespace string.
   - All code comments and documentation are maintained in English to facilitate clean git rebases, cherry-picks, and upstream syncs.

---

## 🗺️ 2. Complete Project Topology

```text
rvim/
├── init.lua                          # 🚪 Lifecycle bootstrapper & global API injector
├── ARCHITECTURE.md                   # 📖 Complete technical architecture guide
├── README.md                         # ⌨️ Installation guide & complete keymaps manual
├── install.sh                        # 📦 Automated installer (symlinks config & pack directories)
├── bin/
│   ├── rvim                          # 🚀 Shell wrapper enforcing NVIM_APPNAME="rvim"
│   ├── rvim-dashboard-notify         # 🔔 High-contrast GitHub notification sanitizer for dashboard
│   ├── rvim-dashboard-issues         # 🐛 Universal GitHub issues widget (repo / global assigned fallback)
│   ├── rvim-dashboard-prs            # 🔀 Universal GitHub pull requests widget (repo / global authored fallback)
│   └── rvim-dashboard-status         # 📊 Universal Git working tree diff & system overview widget
├── nvim-pack-lock.json               # 🔒 Pinned git commit hashes for all vim.pack plugins
│
├── after/                            # ⏱️ LAYER 4: LATE RUNTIME OVERRIDES
│   └── lsp/                          # Per-server LSP configuration files
│       ├── clangd.lua                # C / C++ (NDK) background indexing & UTF-16 offsetEncoding
│       ├── cssls.lua                 # CSS / SCSS / Less lint settings
│       ├── lua_ls.lua                # Neovim runtime library & Lua diagnostics
│       ├── oxlint.lua                # Oxlint high-speed Rust linter daemon
│       └── vtsls.lua                 # TypeScript language server optimization & inlay hints
│
└── lua/rvim/                         # 🛡️ PRIVATE NAMESPACE
    ├── config/                       # ⚙️ LAYER 1: NATIVE CORE (Zero external plugins)
    │   ├── options.lua               # Global vim.opt settings, vim._core.ui2 floating cmdline
    │   ├── keymaps.lua               # 29 native keymaps with register isolation ("_, "0)
    │   ├── autocmds.lua              # Lifecycle events (UserConfig, CursorLine, TextYankPost)
    │   ├── commands.lua              # User commands (:ToggleFormatter, :Copy* clipboard suite)
    │   └── workarounds.lua           # Upstream Neovim bug workarounds (Treesitter fold #40290)
    │
    ├── utils/                        # 🧰 LAYER 2: UTILITIES & SERVICES TOOLKIT
    │   ├── init.lua                  # Aggregator exporting _G.Rvim singleton
    │   ├── icons.lua                 # Centralized Nerd Font glyphs catalog
    │   ├── editor.lua                # Root detection, multi-scope file & dir pickers (Oil float), package.json popup, clipboard utilities
    │   ├── lazygit.lua               # RPC-aware Lazygit terminal wrapper preserving origin pane
    │   ├── lualine.lua               # Reactive statusline components (pretty_path, root_dir, macro)
    │   └── tabline.lua               # Headless tabline renderer with powerline arrow glyphs
    │
    └── plugins/                      # 📦 LAYER 3: PLUGINS ECOSYSTEM
        ├── init.lua                  # vim.pack.add declaration and submodule orchestrator
        ├── ui.lua                    # Solarized Osaka, mini.icons, snacks (98% dashboard, picker), incline, codediff
        ├── treesitter.lua            # 40+ AST parsers, MDX support, syntax highlighter autocommands
        ├── editor.lua                # Blink.cmp, Conform formatting, mini.pairs, Gitsigns, mini.diff
        ├── lsp.lua                   # Mason tool installer, Blink LSP capability bridge, lsp.enable
        ├── util.lua                  # Oil.nvim (editable directory buffers) and Copilot ghost text
        ├── octohub.lua               # GitHub repository explorer & stats engine (Pickme + Snacks)
        ├── seeker.lua                # Seeker.nvim bidirectional file & grep search bridge (Snacks picker)
        ├── homegrown.lua             # Homegrown.nvim suite (live MD preview, code runner, autotiling, bracket nav, replace)
        ├── render-markdown.lua       # Render-markdown.nvim (Obsidian & GitHub callouts, tables, checkboxes, headers)
        ├── tfm.lua                   # Terminal File Manager integration with elio (/usr/bin/elio)
        ├── keymaps.lua               # Plugin-dependent keymaps (Snacks pickers, LSP navigation, Git, TFM)
        └── which-key.lua             # Keymap visual popup guide, express root actions (<space>, ,, /, :, x, z) & 10 unified suites (b, c, d, e, g, m, s, t, y, ;)
```

---

## ⚡ 3. Boot Lifecycle & Execution Order

```
[bin/rvim]
    │  Sets NVIM_APPNAME="rvim"
    ▼
[init.lua]
    │  1. vim.loader.enable()  ---> Compiles Lua to bytecode & caches &rtp (~/.cache/rvim/luacache)
    │  2. _G.Rvim = require("rvim.utils") ---> Exposes global services singleton
    ▼
[Layer 1: Native Core]
    │  • rvim.config.options   ---> vim.opt, vim.g, experimental UI2
    │  • rvim.config.keymaps   ---> 26 native keymaps & safe registers ("0, "_), <leader>z force quit
    │  • rvim.config.autocmds  ---> TextYankPost, reactive CursorLine
    │  • rvim.config.commands  ---> User commands (:ToggleFormatter, :Copy* suite)
    │  • rvim.config.workarounds -> Upstream patches
    ▼
[Layer 3: Plugins Ecosystem (vim.pack.add)]
    │  Resolves git repositories from ~/.local/share/rvim/site/pack/core/opt/
    │  • ui         ---> Theme, Lualine, Incline, Snacks setup (RVIM banner, 98% edge-to-edge modals)
    │  • treesitter ---> AST grammars & dynamic syntax start
    │  • editor     ---> Blink.cmp engine, Conform formatter, Gitsigns, Mini.pairs
    │  • lsp        ---> Mason package installer, Blink LSP capability injection
    │  • util       ---> Oil.nvim editable directory buffers (edge-to-edge float), GitHub Copilot
    │  • octohub    ---> GitHub repository manager, stats & pickme bridge to snacks
    │  • seeker     ---> Seeker.nvim bidirectional file & grep search bridge (Snacks picker)
    │  • homegrown  ---> Homegrown.nvim utility suite (runner, md preview, autotile, replace)
    │  • render-markdown -> Render-markdown.nvim aesthetic callouts, tables, and badge decorations
    │  • tfm        ---> Terminal File Manager bridge configuring elio with edge-to-edge floating modal
    │  • keymaps    ---> Binds Snacks pickers, LSP definitions, CodeDiff, Lazygit, TFM
    │  • which-key  ---> WhichKey visual menu, express root actions (<space>, ,, /, :, x, z) & 10 interactive suites (b, c, d, e, g, m, s, t, y, ;)
    ▼
[Layer 4: Late Runtime Overrides (&rtp: after/lsp/)]
       • Loads after/lsp/<server>.lua after lspconfig initializes
```

---

## 🧩 4. In-Depth Layer Breakdown

### Layer 0: Bootstrapping & Caching (`init.lua`)
- **`vim.loader.enable()`**: Compiles all Lua modules on first run into bytecode stored in `~/.cache/rvim/luacache`. On subsequent runs, Neovim validates file modification timestamps and directly loads bytecode, eliminating Lua interpretation overhead and cutting boot time down to < 5 ms.
- **Global Injection `_G.Rvim`**: Initialized immediately after `vim.loader`. Components across the editor access `_G.Rvim.icons` or `_G.Rvim.editor` directly without repeated filesystem lookups via `require()`.

---

### Layer 1: Native Core (`lua/rvim/config/`)
Provides a zero-plugin vanilla editing environment:
- **`options.lua`**:
  - Indentation: 2 spaces (`tabstop = 2`, `shiftwidth = 2`, `expandtab = true`, `smartindent = true`).
  - Persistent undo: `undofile = true`, storing history across reboots in `~/.cache/nvim/undodir`.
  - Native Floating UI (`vim._core.ui2`): Neovim 0.12+ experimental UI capturing command line, messages, and pagers into floating dialogs.
  - Viewports: `scrolloff = 10`, `sidescrolloff = 8`, `cursorline = true`, `termguicolors = true`, clean end-of-buffer (`eob = " "`).
- **`keymaps.lua`**:
  - **Register Isolation**: Remaps destructive deletions (`d`, `x`, `c`) to the black hole register (`"_`), preventing clipboard pollution.
  - **Prioritized Pasting**: `<Space> + p` pastes from register `"0` (the last deliberate yank).
  - **Universal Quick Save**: `<Ctrl> + s` saves the current buffer immediately from any mode (`n`, `i`, `x`, `s`).
  - **Search Highlight Reset**: `<Esc>` in normal mode clears search highlights (`nohlsearch`).
  - **Visual Block Bubble**: `J` and `K` in visual mode slide highlighted blocks up and down with dynamic reindentation (`:m '>+1<CR>gv=gv`).
  - **Window Splits**: `ss` (horizontal), `sv` (vertical), equalization via `<Space> + se` (`<C-w>=`), fast close via `<Space> + sx` (`:close`), navigation via `sh`, `sj`, `sk`, `sl`.
  - **Tabs**: `te` (`:tabedit`), `<Tab>` (next), `<S-Tab>` (previous).
- **`autocmds.lua`**:
  - `TextYankPost`: High-visibility flash on copied text (`vim.highlight.on_yank()`).
  - `CursorLine`: Automatically toggles `cursorline` on only the currently focused window (`WinEnter` / `WinLeave`), eliminating visual clutter.
  - `InsertLeave`: Resets `nopaste` mode upon leaving insert mode.
- **`commands.lua`**: Defines `:ToggleFormatter` command.
- **`workarounds.lua`**: Intercepts `OptionSet` to delete broken Treesitter fold refresh autocmds triggering upstream bug `#40290`.

---

### Layer 2: Services and Utilities (`lua/rvim/utils/`)
Reusable service layer decoupled from plugins:
- **`init.lua`**: Consolidates `icons`, `lualine`, `tabline`, and `editor` into the singleton table `_G.Rvim`.
- **`icons.lua`**: Comprehensive Nerd Font glyph catalog (UI, documents, types, LSP kinds, diagnostics, and git changes) integrated from nvim2k.
- **`editor.lua`**:
  - Project root detection via upward directory traversal looking for markers (`.git`, `lua`, `package.json`, `Makefile`, etc.).
  - `open_package_json()`: Opens project `package.json` in an edge-to-edge full width and 98% height floating modal anchored at row 0, with buffer-local `<Esc>` / `q` close handlers.
  - `copy_as_codeblock()`: Formats visual selections into GitHub-ready Markdown blocks with language metadata and line numbers (` ```tsx filename="src/App.tsx" line=42 `).
  - `delete_hidden_buffers()`: Iterates `vim.api.nvim_list_bufs()`, checks visibility against `vim.api.nvim_list_wins()`, and safely closes inactive unedited buffers.
  - `toggle_formatter()`: Toggles buffer-local variable `vim.b[bufnr].disable_autoformat`.
  - Path permalinks: `yank_relative_path_with_line()` and `yank_absolute_path_with_line()` format paths with standard `#L{line}` suffixes.
- **`lazygit.lua`**:
  - Preserves `origin_win` before opening LazyGit in a floating terminal.
  - Implements an IPC mechanism using Neovim's active socket (`nvim --server "$NVIM"`). When a file is selected inside LazyGit (`e`), it signals Neovim to refocus `origin_win` and open the file in the existing pane.
- **`lualine.lua`**: Provides `pretty_path()` (path truncation with `…`), `root_dir()` (context-aware project basename display), and `macro_recording()` indicator.
- **`tabline.lua`**: Renders clickable tab headers using powerline triangles (``, ``) and buffer icons.

---

### Layer 3: Plugins Ecosystem (`lua/rvim/plugins/`)
Managed natively via `vim.pack.add` using pinned hashes in `nvim-pack-lock.json`:
- **`init.lua`**: Declaratively registers all 31 core plugins via GitHub URLs and executes plugin setup modules in strict sequential order.
- **`ui.lua`**:
  - `solarized-osaka.nvim`: Vivid, transparent color scheme.
  - `mini.icons`: Lightweight icons library with `mock_nvim_web_devicons()`.
  - `snacks.nvim`: Notifier, statuscolumn, smooth indent guides, word highlight, and declarative multi-pane startup dashboard (RVIM ANSI shadow banner, dynamic time greeting, cursor hiding/virgulillas suppression, Solarized Osaka theme synchronization, fast navigation/maintenance keys, terminal color scripts, wttr.in weather telemetry, GitHub CLI notifications, issues, PRs, and live git status).
  - `incline.nvim`: Subtle floating pill in the top-right corner of each window displaying filename and modified status.
  - `codediff.nvim`: Two-way interactive diff comparison viewer.
  - `lualine.nvim`: Statusline configured with mode, branch, root directory, pretty path, macro status, diagnostics, and git hunks.
- **`treesitter.lua`**:
  - Installs 45+ grammars (`astro`, `bash`, `c`, `cmake`, `cpp`, `css`, `diff`, `fish`, `gitignore`, `go`, `graphql`, `groovy`, `html`, `http`, `java`, `javascript`, `jsdoc`, `json`, `kotlin`, `lua`, `luadoc`, `luap`, `markdown`, `markdown_inline`, `php`, `printf`, `properties`, `python`, `qmljs`, `query`, `regex`, `rust`, `scss`, `sql`, `svelte`, `toml`, `tsx`, `typescript`, `vim`, `vimdoc`, `xml`, `yaml`).
  - Registers filetype and language mappings for MDX (`markdown`) and QML (`qmljs`).
  - Automatically starts highlighter and indentation expression on `FileType` events.
  - Binds `PackChanged` event to run `TSUpdate`.
- **`editor.lua`**:
  - `blink.cmp`: High-performance completion engine written in Rust, configured with auto-brackets, cmdline completion, and `Rvim.icons.kinds`.
  - `conform.nvim`: Format-on-save pipeline with `oxfmt` (falls back to `prettierd` and `prettier`), `stylua`, `shfmt`, `fish_indent`, `clang-format` (C/C++), `ktlint` (Kotlin), `google-java-format` (Java), `xmlformatter` (XML / Android layouts), `npm-groovy-lint` (Gradle / Groovy), and `black` / `ruff_format` (Python).
  - `mini.pairs`: Autocloses parentheses, quotes, and markdown backticks, with Treesitter string node awareness.
  - `gitsigns.nvim` & `mini.diff`: Git hunk indicators in the signcolumn, inline diff overlays (`<Space> + gd`), line/buffer blame (`<Space> + gb`), and hunk staging.
  - `nvim-highlight-colors`: Real-time color preview (hex, rgb, hsl).
  - `todo-comments.nvim`: Highlights and searches `TODO:`, `FIXME:`, `NOTE:` tags.
- **`lsp.lua`**:
  - `mason.nvim` & `mason-tool-installer.nvim`: Automates installation of LSP servers, linters, and formatters (`vtsls`, `lua-language-server`, `prettier`, `oxlint`, `rust-analyzer`, `kotlin-language-server`, `ktlint`, `jdtls`, `google-java-format`, `lemminx`, `xmlformatter`, `bash-language-server`, `pyright`, `clangd`, `clang-format`, etc.).
  - Bridges Blink.cmp completion capabilities into all LSP servers via `vim.lsp.config("*", ...)`.
  - Enables active language servers (`eslint`, `oxlint`, `lua_ls`, `cssls`, `vtsls`, `tailwindcss`, `glsl_analyzer`, `rust_analyzer`, `clangd`, `bashls`, `pyright`, `kotlin_language_server`, `jdtls`, `lemminx`, `qmlls`).
- **`util.lua`**:
  - `oil.nvim`: File manager that lets you edit filesystem directories just like normal text buffers (`sf`).
  - `copilot.lua`: Inline AI code completion suggestions with `<C-l>` accept.
- **`octohub.lua`**:
  - `octohub.nvim`: Manages and explores GitHub repositories directly inside Neovim, caching repositories, stats, and contribution graphs.
  - `pickme.nvim`: Bridges picker requests directly to `snacks.picker` for unified fuzzy search and selection.
  - `utils.nvim`: Provides asynchronous shell execution, caching, and notification utilities.
- **`seeker.lua`**:
  - `seeker.nvim`: Bidirectional search bridge between file lists and ripgrep queries in `snacks.picker`. Pressing `<Ctrl> + e` switches between matched files and a ripgrep search restricted to those exact files.
- **`homegrown.lua`**:
  - `homegrown.nvim`: Lightweight, zero-dependency suite providing real-time browser markdown preview without external servers (`:MDPreview`), asynchronous code runner (`:Runner`), aspect-ratio window autotiling (`:AutoTile`), project-wide search and replace (`:Replace`), git root switcher (`:RootDir`), and conflict/line bracket motions (`[x`/`]x`, `[<space>`/`]<space>`).
- **`render-markdown.lua`**:
  - `render-markdown.nvim`: In-buffer and Snacks picker preview document renderer. Formats callouts, boxes, checkboxes, Unicode tables, and headers with live concealment and no line numbers in picker previews.
- **`tfm.lua`**:
  - `tfm.nvim`: Integrates the high-speed terminal file manager `/usr/bin/elio` via `--chooser-file`. Automatically configures `:Tfm`, `:TfmSplit`, `:TfmVsplit`, `:TfmTabedit` commands, interactive in-buffer split overrides (`<C-v>`, `<C-x>`, `<C-t>`), and full-width 98% height floating modal matching the editor design language.
- **`keymaps.lua`**: Binds all plugin-dependent keys (Snacks file/grep pickers `;f`/`;r`, document symbols `;s`, recent files `;o`, buffers `\\`, LSP navigation `gd`/`gr`/`K`, CodeLens, formatting `<Space> + f`, TFM `;t`).
- **`which-key.lua`**:
  - `which-key.nvim`: Floating keymap visual guide with modern layout, centered alignment, and Nerd Font icons.
  - Complete Git Suite (`<Space> + g`): Provides the interactive Git dashboard with 22 top-level actions, GitHub issue/PR submenus, Octohub repository browsing, and Gitsigns visual toggles.
  - `co-author.nvim`: Fuzzy picker integrating with `snacks.picker` to insert co-authors from repository commit history (`<Space> + gC`).

---

### Layer 4: Late LSP Runtime Overrides (`after/lsp/`)
Neovim automatically evaluates the `after/` directory at the end of its startup cycle. Files named `<server>.lua` in `after/lsp/` automatically inject fine-tuned settings into their corresponding LSP servers:
- **`clangd.lua`**: Sets UTF-16 offset encoding (`offsetEncoding = { "utf-16" }`) to eliminate client-server offset mismatches, enables background AST indexing, Clang-Tidy static analysis, IWYU header insertion, and detailed completion documentation for C/C++ and Android NDK.
- **`vtsls.lua`**: Enables inlay hints (enum member values, return types, parameter names), automatic import updating on file move, and optimizes semantic tokens.
- **`lua_ls.lua`**: Configures Neovim runtime library indexing (`vim.env.VIMRUNTIME`), enables inlay hints, and silences noise for internal variables (`_*`).
- **`oxlint.lua`**: Configures the ultra-fast Rust-based linter daemon with `--lsp`.
- **`cssls.lua`**: Silences empty rule lint warnings for CSS, SCSS, and Less.

---

## 🔒 5. Keymap Rules & Mental Model

1. **Space Leader (`<Space>`)**:
   - Reserved for major actions, formatting, diagnostics, safe destructive operations, and git commands:
   - `<Space> + z`: Force quit all buffers immediately without saving (`:qa!<CR>`)
   - `<Space> + f`: Format code
   - `<Space> + ca`: Code actions
   - `<Space> + cr`: Rename symbol
   - `<Space> + p`: Safe paste from register `"0`
   - `<Space> + gb` / `gs` / `gh`: Git blame and staging
2. **Direct Prefix Keys (No Space)**:
   - Reserved for ultra-fast, high-frequency navigation:
   - `;f` (files), `;r` (live grep), `\\` (open buffers), `;;` (resume search), `;g` (lazygit), `;t` (elio terminal file manager)
   - `sf` (oil file explorer)
   - `ss` / `sv` (horizontal/vertical split), `sh`/`sj`/`sk`/`sl` (focus navigation)
   - `te` (new tab), `<Tab>` / `<S-Tab>` (cycle tabs)
   - `gd` (definition), `gr` (references), `K` (hover doc)

---

## 🛠️ 6. Maintenance & Extension Playbook

- **Add or change native settings**: Edit `lua/rvim/config/options.lua`.
- **Add native keymaps**: Edit `lua/rvim/config/keymaps.lua`.
- **Install a new plugin**:
  1. Add `{ src = gh("owner/repo") }` to `vim.pack.add` in `lua/rvim/plugins/init.lua`.
  2. Configure it in its respective category file (`ui.lua`, `editor.lua`, etc.).
  3. Lock the commit hash in `nvim-pack-lock.json`.
- **Add or fine-tune an LSP server**:
  1. Add to `ensure_installed` in `lua/rvim/plugins/lsp.lua`.
  2. Add the server name to `vim.lsp.enable({ ... })`.
  3. Create `after/lsp/<server_name>.lua` to supply custom server settings.
- **Syncing with upstream**:
  Because code divergence is strictly restricted to the `rvim` namespace, upstream changes from Craftzdog can be incorporated via git patch or merge with minimal conflict resolution.
