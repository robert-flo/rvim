# 🏛️ rvim Architecture: Technical and Conceptual Guide

Reference documentation to understand the internal architecture, lifecycle, dependency flow, and design decisions in `rvim`.

---

## 🎯 Design Philosophy

1. **Native Neovim 0.12+**: Avoids external plugin managers (`lazy.nvim`, `packer`). Uses native declarative `vim.pack.add` and bytecode compiler `vim.loader`.
2. **Decoupled Layered Architecture**: The editor must remain 100% usable, fast, and comfortable without any external plugins (Vanilla Core mode). Plugins are enhancements, not mandatory foundations.
3. **Strict Namespace Isolation (`lua/rvim/`)**: All internal modules live under the `rvim/` prefix within `runtimepath`, preventing naming collisions with third-party libraries or plugins.
4. **Resilience & Performance**: Cold startup time under 5 ms via bytecode caching and lazy-loading of heavier utilities.

---

## 🗺️ Project Topological Map

```text
rvim/
├── init.lua                          # 🚪 Neovim lifecycle bootstrapper
├── ARCHITECTURE.md                   # 📖 This architecture document
├── README.md                         # ⌨️ Usage docs and active keymaps table
├── install.sh                        # 📦 Installer and symlink script (~/.config/rvim)
├── bin/rvim                          # 🚀 Launcher wrapper with NVIM_APPNAME="rvim"
├── after/                            # ⏱️ Late Runtime (post-plugin initialization)
│   └── lsp/                          # 🔌 Per-server language configurations (lua_ls, vtsls, etc.)
└── lua/rvim/                         # 🛡️ Private namespace
    ├── config/                       # ⚙️ LAYER 1: NATIVE CORE (Zero plugins, vanilla Neovim)
    │   ├── options.lua               # Global vim.opt settings and environment variables
    │   ├── keymaps.lua               # Native keymaps (splits, tabs, buffers, safe registers)
    │   ├── autocmds.lua              # Lifecycle events (TextYankPost, reactive CursorLine)
    │   ├── commands.lua              # User commands (:ToggleFormatter)
    │   └── workarounds.lua           # Upstream bug workarounds
    ├── utils/                        # 🧰 LAYER 2: GLOBAL SERVICES AND HELPERS
    │   ├── init.lua                  # Exposes `_G.Rvim` as global API
    │   ├── icons.lua                 # Centralized Nerd Font glyphs dictionary
    │   ├── editor.lua                # Path manipulation, floating buffers, markdown copy
    │   ├── lazygit.lua               # Decoupled floating terminal for LazyGit
    │   ├── lualine.lua               # Reactive statusline components
    │   └── tabline.lua               # Top tabline rendering
    └── plugins/                      # 📦 LAYER 3: ECOSYSTEM & PLUGINS MANAGEMENT
        ├── init.lua                  # Declarative package sources via vim.pack.add
        ├── ui.lua                    # Solarized Osaka, Lualine, Incline, Trouble
        ├── treesitter.lua            # AST parsers, syntax highlighting, and folding
        ├── editor.lua                # Blink.cmp (Rust), Conform.nvim, Mini.pairs, Gitsigns
        ├── lsp.lua                   # Mason, Mason-tool-installer, Nvim-lspconfig
        ├── util.lua                  # Oil.nvim (directory as buffer), Copilot
        └── keymaps.lua               # Plugin-dependent keymaps only
```

---

## ⚡ Lifecycle and Startup Flow

```
[bin/rvim]
    │  Sets NVIM_APPNAME="rvim"
    ▼
[init.lua]
    │  1. vim.loader.enable()  ---> Compiles Lua to bytecode & caches &rtp (~/.cache/rvim/luacache)
    │  2. _G.Rvim = require("rvim.utils") ---> Injects global helper API
    ▼
[Layer 1: Native Core]
    │  • rvim.config.options   ---> vim.opt, vim.g, experimental UI2
    │  • rvim.config.keymaps   ---> Native keymaps and safe registers ("0, "_)
    │  • rvim.config.autocmds  ---> TextYankPost, reactive CursorLine
    │  • rvim.config.commands  ---> User commands (:ToggleFormatter)
    │  • rvim.config.workarounds -> Upstream patches
    ▼
[Layer 3: Plugins (vim.pack.add)]
    │  Clones / links packages into ~/.local/share/rvim/site/pack/core/opt/
    │  • ui (Colors, status, floating windows)
    │  • treesitter (AST syntax parsers)
    │  • editor (Completion, formatting, autopairs)
    │  • lsp (Mason, Language Servers)
    │  • util (Oil.nvim, Copilot)
    │  • plugins.keymaps (Plugin-dependent keymaps: Snacks, LSP, Oil)
    ▼
[Layer 4: Late Runtime (&rtp: after/lsp/)]
       • Loads after/lsp/<server>.lua after lspconfig initializes
```

---

## 🧩 Detailed Layer Breakdown

### Layer 0: Bootstrapping & Caching (`init.lua`)
- **`vim.loader.enable()`**: Enables Neovim's built-in bytecode loader. Instead of reading, parsing, and compiling `.lua` files from disk on every launch, Neovim validates timestamps and reads compiled bytecode, dramatically reducing startup time.
- **Global Injection `_G.Rvim`**: Defined before plugins load to eliminate redundant `require()` calls across hot paths such as statusline components and frequent keymaps.

### Layer 1: Native Core (`lua/rvim/config/`)
Completely independent of external packages:
- **`options.lua`**:
  - Standard 2-space indentation (`tabstop`, `shiftwidth`, `expandtab`).
  - Persistent undo across sessions (`undofile` in `~/.cache/nvim/undodir`).
  - Enables modern floating UI via `vim._core.ui2` (messages, command line, and dialogs in native floating windows).
- **`keymaps.lua`**:
  - **Register Isolation**: In Vim, standard deletion (`d`, `x`) overwrites the default clipboard. Here, destructive operations target the black hole register (`"_`), while safe pasting pulls from register `"0` (the last genuine yank).
  - **Window Navigation**: Splits created with `ss` (horizontal) and `sv` (vertical); focus shifted using `sh`, `sj`, `sk`, `sl`.
- **`autocmds.lua`**:
  - Instant visual feedback on copied text (`vim.highlight.on_yank`).
  - Dynamic `CursorLine`: line highlight is active only in the focused window and disabled on `WinLeave` to minimize visual noise.
- **`workarounds.lua`**:
  - Contains documented patches for upstream Neovim bugs, isolated so they can be removed once resolved in newer releases.

### Layer 2: Services and Utilities (`lua/rvim/utils/`)
Reusable toolkit and service layer decoupled from external plugins, exposed globally via `_G.Rvim`:

- **`init.lua` (The Aggregator & Singleton)**:
  - Consolidates and re-exports `icons`, `lualine`, `tabline`, and `editor`.
  - Injected directly into the Lua global table as `_G.Rvim = require("rvim.utils")` during boot in `init.lua`, giving all commands, keymaps, and UI components zero-overhead access without redundant `require()` calls.

- **`icons.lua` (Centralized Nerd Font Dictionary)**:
  - Structured, categorized glyph tables for:
    - `diagnostics`: `Error` (), `Warn` (), `Hint` (), `Info` ().
    - `git`: `added` (), `modified` (), `removed` ().
    - `kinds`: Comprehensive LSP completion item symbols (Function, Method, Variable, Class, Interface, Copilot, etc.).
    - `dap`: Debugger breakpoints, stopped lines, and condition indicators.
  - Centralizing icons ensures typography and glyph updates require modifying exactly one file.

- **`editor.lua` (Editing & Buffer Mechanics)**:
  - **Project Root Discovery**: Upward traversal searching for `root_patterns` (`.git`, `lua`, `package.json`, `Makefile`, `Cargo.toml`, `go.mod`, `pyproject.toml`) with path normalization across symlinks.
  - **`open_package_json()`**: Calculates dynamic floating window dimensions (80% width/height of the editor grid), centers the window, loads `package.json`, and attaches buffer-local `<Esc>` / `q` close mappings.
  - **`copy_as_codeblock()`**: Converts visual selection into a GitHub/GitLab-ready Markdown code fence with language detection, relative filename, and starting line number metadata (e.g., ````tsx filename="src/App.tsx" line=42````).
  - **`delete_hidden_buffers()`**: Queries `vim.api.nvim_list_bufs()`, checks active visibility against `vim.api.nvim_list_wins()`, and safely deletes inactive buffers while guarding dirty/unwritten buffers.
  - **`toggle_formatter()`**: Flips the buffer-local flag `vim.b[bufnr].disable_autoformat`, consumed downstream by formatting engines like Conform.nvim.
  - **Path Permalinks**: `yank_relative_path_with_line()` and `yank_absolute_path_with_line()` format paths with standard `#L{line}` suffixes for instant sharing in code reviews.

- **`lazygit.lua` (RPC-Aware Terminal Integration)**:
  - **Origin Window Preservation**: Remembers the exact window ID (`origin_win`) from which LazyGit was triggered.
  - **IPC Communication**: Leverages Neovim's active socket via `nvim --server "$NVIM"` to send RPC commands (`--remote-send`, `--remote`). When a file is selected for editing inside LazyGit (`e`), LazyGit signals the parent Neovim instance to focus `origin_win` and open the file in the existing pane rather than spawning duplicate tabs.

- **`lualine.lua` (Statusline Component Primitives)**:
  - **`pretty_path()`**: Condenses file paths relative to project root or cwd, truncates deep hierarchies with an ellipsis (`src/…/components/Button.tsx`), highlights directories separately from filenames, and dynamically reflects modified / readonly states.
  - **`root_dir()`**: Renders project root basename with conditional visibility (hides when cwd equals root, shows when navigating subdirectories).
  - **`macro_recording()`**: Reactive macro indicator tied to `RecordingEnter`/`RecordingLeave` events.

- **`tabline.lua` (Headless Tabline Renderer)**:
  - Independent tabline renderer (`tabline.render()`) implementing powerline lower triangles (``, ``).
  - Encodes clickable tab page indices (`%1T...%T`).
  - Introspects buffers per tab, resolves filetype icons via `mini.icons`, and cleanly displays special buffer titles (e.g., `[Terminal]`, truncated Oil directory paths).


### Layer 3: Plugins (`lua/rvim/plugins/`)
- **`init.lua` (`vim.pack.add`)**:
  - Declarative list of GitHub plugin sources.
  - Neovim manages packages following standard Vim/Neovim pack conventions without background daemons or intermediate databases.
- **Keymaps Separation**:
  - Keymaps referencing `Snacks.picker`, `Oil`, or `vim.lsp.buf` reside in `plugins/keymaps.lua`. If a plugin is disabled or troubleshooting occurs, native keymaps in `config/keymaps.lua` continue to work without throwing Lua errors.

### Layer 4: Late LSP Configuration (`after/lsp/`)
- Neovim evaluates the `after/` directory after processing the main configuration.
- Storing configurations like `after/lsp/vtsls.lua` or `after/lsp/lua_ls.lua` keeps individual Language Server tweaks isolated, avoiding huge single-file LSP configs.

---

## 🔒 Keymap Conventions and Rules

1. **`<Leader>` is mapped to Space (`<Space>`)**.
2. **Keymaps with `<Space>`**: Reserved for global actions, safe destructive workflows, diagnostics, and major tools (`<Space> + f` for formatting, `<Space> + ca` for Code Actions).
3. **Direct Keymaps (Without `<Space>`)**: Tailored for high-frequency navigation:
   - `;f`: File picker
   - `;r`: Live Grep
   - `sf`: File explorer (Oil)
   - `ss` / `sv`: Window split
   - `sh` / `sj` / `sk` / `sl`: Window focus shift
   - `te`: New tab

---

## 🛠️ Maintaining and Extending the Configuration

- **Add a native setting**: Edit `lua/rvim/config/options.lua`.
- **Add a native keymap**: Edit `lua/rvim/config/keymaps.lua`.
- **Install a plugin**: Add `{ src = gh("author/repository") }` to `lua/rvim/plugins/init.lua` and configure it in its respective category file (`ui.lua`, `editor.lua`, etc.).
- **Add an LSP server**: Register it in `mason` inside `lua/rvim/plugins/lsp.lua` and optionally add fine-tuned overrides under `after/lsp/<server_name>.lua`.
