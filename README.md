# rvim

Modular, ultra-fast, and isolated Neovim configuration (`NVIM_APPNAME="rvim"`), crafted upon Craftzdog's high-performance architecture using Neovim 0.12+ with native `vim.pack.add` package management.

For the in-depth architectural breakdown, lifecycle diagrams, and design decisions, refer to [ARCHITECTURE.md](ARCHITECTURE.md).

---

## 🚀 Installation & Usage

```bash
# Clone the repository
git clone https://github.com/robert-flo/rvim.git ~/.config/rvim

# Run installation script (symlinks binaries and configurations)
cd ~/.config/rvim
./install.sh

# Launch rvim
rvim
```

---

## ⌨️ Complete Keymaps Reference

> ⚠️ **Keymap Rules**:
> - **`<Space>` Leader**: Press Space first, then the following key (e.g., `<Space> + f`).
> - **Direct Keys**: Pressed sequentially without Space (e.g., `;r` is typed directly as `;` followed by `r`).

---

### ⚡ 1. Daily Essentials

| Space? | Keymap | Action |
| :---: | :--- | :--- |
| ❌ **NO** | **`;f`** | **Find files** in project (`Snacks.picker.files`) |
| ❌ **NO** | **`;r`** | **Live Grep** across project text (`Snacks.picker.grep`) |
| ❌ **NO** | **`;s`** | **Document Symbols** / outline fuzzy picker (`Snacks.picker.lsp_symbols`) |
| ❌ **NO** | **`;o`** | **Recent files** picker (`Snacks.picker.recent`) |
| ❌ **NO** | **`sf`** | **Floating file explorer** (`Oil.nvim`) |
| ❌ **NO** | **`\\`** | **List open buffers** (`Snacks.picker.buffers`) |
| ❌ **NO** | **`;;`** | **Resume** last closed search picker |
| ❌ **NO** | **`;g`** | **Open Lazygit** in integrated floating terminal |
| ❌ **NO** | **`<Ctrl> + s`** | **Quick save** file from any mode (Normal, Insert, Visual) |
| ❌ **NO** | **`<Esc>`** | **Clear search highlights** (`nohlsearch`) |
| ✅ **YES** | **`<Space> + f`** | **Format code** with Conform (Prettier / Ktlint / Clang / Stylua) |
| ❌ **NO** | **`gcc`** | Toggle line comment |
| ❌ **NO** | **`gc`** *(Visual)* | Toggle block comment |
| ❌ **NO** | **`ss`** | Split window horizontally (`:split`) |
| ❌ **NO** | **`sv`** | Split window vertically (`:vsplit`) |
| ✅ **YES** | **`<Space> + se`** | Equalize all split window dimensions (`<C-w>=`) |
| ✅ **YES** | **`<Space> + sx`** | Close current split window (`:close`) |
| ❌ **NO** | **`sh`** / **`sj`** / **`sk`** / **`sl`** | Focus window Left / Down / Up / Right |
| ❌ **NO** | **`te`** | Open new clean tab (`:tabedit`) |
| ❌ **NO** | **`<Tab>`** / **`<S-Tab>`** | Switch to next / previous tab |

---

### 📝 2. Editing & Safe Clipboard Registers

| Space? | Keymap | Mode | Action |
| :---: | :--- | :---: | :--- |
| ✅ **YES** | **`<Space> + p`** | Normal / Visual | **Paste last yank**: uses register `0`, ignoring deletions with `d` or `x` |
| ✅ **YES** | **`<Space> + P`** | Normal | Paste before cursor from register `0` |
| ✅ **YES** | **`<Space> + c`** | Normal / Visual | Change text into black hole register (`"_c`) without overwriting clipboard |
| ✅ **YES** | **`<Space> + C`** | Normal / Visual | Change to end of line into black hole register (`"_C`) |
| ✅ **YES** | **`<Space> + d`** | Normal / Visual | Delete text into black hole register (`"_d`) |
| ✅ **YES** | **`<Space> + D`** | Normal / Visual | Delete to end of line into black hole register (`"_D`) |
| ✅ **YES** | **`<Space> + o`** | Normal | Insert clean line below without auto-continuing comments |
| ✅ **YES** | **`<Space> + O`** | Normal | Insert clean line above without auto-continuing comments |
| ✅ **YES** | **`<Space> + yf`** | Normal | Copy relative path with line number (e.g., `src/app.ts:42`) |
| ✅ **YES** | **`<Space> + yp`** | Normal | Copy absolute path with line number |
| ✅ **YES** | **`<Space> + cc`** | Visual | Copy selection formatted as Markdown code block |
| ✅ **YES** | **`<Space> + j`** | Normal | Open project `package.json` in centered 80% floating window |
| ❌ **NO** | **`x`** | Normal | Delete single character into black hole register (`"_x`) |
| ❌ **NO** | **`dw`** | Normal | Delete word backward without polluting clipboard (`vb"_d`) |
| ❌ **NO** | **`<Ctrl> + a`** | Normal | Select entire buffer (`gg<S-v>G`) |
| ❌ **NO** | **`<Ctrl> + s`** | Any | Save file immediately (`:w<CR>`) and return to normal mode |
| ❌ **NO** | **`J`** | Visual | Move selected block down 1 line maintaining indentation (`:m '>+1<CR>gv=gv`) |
| ❌ **NO** | **`K`** | Visual | Move selected block up 1 line maintaining indentation (`:m '<-2<CR>gv=gv`) |
| ❌ **NO** | **`+`** / **`-`** | Normal | Increment / decrement number under cursor |
| ❌ **NO** | **`<Ctrl> + m`** | Normal | Jump forward in jumplist |

---

### 🧠 3. LSP, Diagnostics & Code Intelligence

| Space? | Keymap | Mode | Action |
| :---: | :--- | :---: | :--- |
| ✅ **YES** | **`<Space> + ca`** | Normal / Visual | **Code Actions** (Quick fixes, refactors) |
| ✅ **YES** | **`<Space> + cr`** | Normal | **Rename symbol** across whole project (*LSP Rename*) |
| ✅ **YES** | **`<Space> + cR`** | Normal | Rename file on disk and update imports automatically |
| ✅ **YES** | **`<Space> + cc`** | Normal / Visual | Run CodeLens under cursor |
| ✅ **YES** | **`<Space> + cC`** | Normal | Refresh CodeLens in buffer |
| ✅ **YES** | **`<Space> + cl`** | Normal | Show active LSP servers information |
| ✅ **YES** | **`<Space> + i`** | Normal | Toggle LSP inlay hints |
| ❌ **NO** | **`gd`** | Normal | **Goto definition** under cursor (`Snacks.picker.lsp_definitions`) |
| ❌ **NO** | **`gD`** | Normal | Goto declaration |
| ❌ **NO** | **`gy`** | Normal | Goto type definition |
| ❌ **NO** | **`gr`** | Normal | Find all references |
| ❌ **NO** | **`gI`** | Normal | Goto source definition / implementation |
| ❌ **NO** | **`K`** | Normal | Display hover documentation |
| ❌ **NO** | **`gK`** | Normal | Display signature help |
| ❌ **NO** | **`<Ctrl> + k`** | Insert | Show function arguments popup while typing |
| ❌ **NO** | **`<Ctrl> + j`** | Normal | Jump to next error or diagnostic in buffer |
| ❌ **NO** | **`;s`** | Normal | **Document Symbols** picker (functions, classes, methods via `Snacks.picker.lsp_symbols`) |
| ❌ **NO** | **`;o`** | Normal | **Recent files** picker (`Snacks.picker.recent`) |
| ❌ **NO** | **`;e`** | Normal | List all diagnostics across project (`Snacks.picker.diagnostics`) |
| ❌ **NO** | **`;c`** | Normal | List incoming calls to function under cursor |
| ❌ **NO** | **`]]`** / **`[[`** | Normal | Jump to next / previous reference of symbol under cursor |

---

### 🌿 4. Git & Version Control

| Space? | Keymap | Mode | Action |
| :---: | :--- | :---: | :--- |
| ❌ **NO** | **`;g`** | Normal | **Launch Lazygit** (reusing origin pane on file open) |
| ❌ **NO** | **`;h`** | Normal | Interactive Git hunks picker (`Snacks.picker.git_diff`) |
| ✅ **YES** | **`<Space> + gb`** | Normal | Blame current line |
| ✅ **YES** | **`<Space> + gB`** | Normal | Blame entire buffer |
| ✅ **YES** | **`<Space> + go`** | Normal | Open file in new tab at commit of line blame |
| ✅ **YES** | **`<Space> + gs`** | Normal | Toggle stage / unstage for entire file |
| ✅ **YES** | **`<Space> + gh`** | Normal | Toggle stage / unstage for current hunk |
| ✅ **YES** | **`<Space> + gd`** | Normal | Toggle overlay diff view (`MiniDiff`) |
| ✅ **YES** | **`<Space> + dv`** | Normal | Interactive code comparison (`CodeDiff`) |
| ✅ **YES** | **`<Space> + dh`** | Normal | Git commit history for current file |
| ✅ **YES** | **`<Space> + dH`** | Normal | Git commit history for entire repository |
| ❌ **NO** | **`]c`** / **`[c`** | Normal | Jump to next / previous git diff hunk in file |

---

### 🔍 5. Inside Pickers (`Snacks.picker`)

| Keymap | Action |
| :--- | :--- |
| **`<Esc>`** or **`q`** | Close picker |
| **`<Enter>`** | Open selected file / item |
| **`<Ctrl> + n`** / **`<Ctrl> + p`** | Navigate down / up in results |
| **`<Ctrl> + u`** / **`<Ctrl> + d`** | Scroll preview pane up / down |
| **`<Ctrl> + s`** | Open selected file in horizontal split |
| **`<Ctrl> + v`** | Open selected file in vertical split |
| **`<Ctrl> + t`** | Open selected file in new tab |
| **`<Tab>`** | Select / deselect multiple items |
| **`<Ctrl> + q`** | Send selected items to quickfix list |

---

### 📂 6. Inside File Explorer (`Oil.nvim` with `sf`)

| Keymap | Action |
| :--- | :--- |
| **`<Enter>`** | Open file or enter directory |
| **`h`** | Go to parent directory |
| **`q`** | Close file explorer |
| **`:w`** | Save changes (rename, move, or delete files directly as buffer text) |

---

### 🤖 7. GitHub Copilot & Autocomplete (`blink.cmp`)

| Space? | Keymap | Mode | Action |
| :---: | :--- | :---: | :--- |
| ❌ **NO** | **`<Enter>`** or **`<Ctrl> + y`** | Insert | Accept autocomplete popup suggestion (`blink.cmp`) |
| ❌ **NO** | **`<Ctrl> + l`** | Insert | Accept full Copilot ghost text suggestion |
| ❌ **NO** | **`<Alt> + l`** | Insert | Accept next word from Copilot suggestion |
| ❌ **NO** | **`<Alt> + Shift + l`** | Insert | Accept next line from Copilot suggestion |
| ❌ **NO** | **`<Alt> + ]`** / **`<Alt> + [`** | Insert | Cycle to next / previous Copilot suggestion |
| ❌ **NO** | **`<Ctrl> + ]`** | Insert | Dismiss Copilot suggestion |

---

### 🪟 8. Windows, Tabs & Buffers

| Space? | Keymap | Mode | Action |
| :---: | :--- | :---: | :--- |
| ❌ **NO** | **`ss`** | Normal | Split window horizontally (`:split`) |
| ❌ **NO** | **`sv`** | Normal | Split window vertically (`:vsplit`) |
| ✅ **YES** | **`<Space> + se`** | Normal | Equalize all split window dimensions (`<C-w>=`) |
| ✅ **YES** | **`<Space> + sx`** | Normal | Close current split window (`:close`) |
| ❌ **NO** | **`sh`** / **`sj`** / **`sk`** / **`sl`** | Normal | Move focus Left / Down / Up / Right |
| ❌ **NO** | **`te`** | Normal | Open clean tab (`:tabedit`) |
| ❌ **NO** | **`<Tab>`** / **`<S-Tab>`** | Normal | Navigate next / previous tab |
| ❌ **NO** | **`\\`** | Normal | List open buffers and switch |
| ✅ **YES** | **`<Space> + bd`** | Normal | Delete all hidden buffers not displayed in any window |

---

### 📱 9. Language Support & Toolchains

rvim provides an out-of-the-box development environment for modern Android applications, native systems programming, and scripting:

| Ecosystem / Language | Filetypes | Treesitter Parser | Language Server (LSP) | Formatter / Linter |
| :--- | :--- | :--- | :--- | :--- |
| **Android Kotlin** | `.kt`, `.kts` | `kotlin` | `kotlin_language_server` | `ktlint` |
| **Android Java** | `.java` | `java` | `jdtls` | `google-java-format` / `clang-format` |
| **Android Layouts / XML** | `AndroidManifest.xml`, `res/**/*.xml`, `.xml` | `xml` | `lemminx` | `xmlformatter` / `prettier` |
| **Gradle Build System** | `build.gradle`, `settings.gradle`, `*.properties` | `groovy`, `kotlin`, `properties` | — | `npm-groovy-lint` |
| **Android NDK / C / C++** | `.c`, `.cpp`, `.cc`, `.h`, `.hpp`, `CMakeLists.txt` | `c`, `cpp`, `cmake` | `clangd` (with background indexing) | `clang-format` |
| **Qt / QML** | `.qml` | `qmljs` | `qmlls` | Native / LSP |
| **Shell Scripting** | `.sh`, `gradlew` | `bash` | `bashls` | `shellcheck`, `shfmt` |
| **Python** | `.py` | `python` | `pyright` | `black` / `ruff` |
| **Web & TypeScript** | `.ts`, `.tsx`, `.js`, `.jsx`, `.json` | `typescript`, `tsx`, `javascript`, `json` | `vtsls`, `eslint` | `oxfmt` / `prettierd` / `prettier` |
| **Styling & Markup** | `.css`, `.scss`, `.html`, `.md`, `.mdx` | `css`, `scss`, `html`, `markdown` | `cssls`, `tailwindcss` | `oxfmt` / `prettier` |
| **Systems & Config** | `.rs`, `.lua`, `.toml`, `.yaml` | `rust`, `lua`, `toml`, `yaml` | `rust_analyzer`, `lua_ls` | `stylua` |

