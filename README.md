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
| ❌ **NO** | **`sf`** | **Floating file explorer** (`Oil.nvim`) |
| ❌ **NO** | **`\\`** | **List open buffers** (`Snacks.picker.buffers`) |
| ❌ **NO** | **`;;`** | **Resume** last closed search picker |
| ❌ **NO** | **`;g`** | **Open Lazygit** in integrated floating terminal |
| ✅ **YES** | **`<Space> + f`** | **Format code** with Prettier / Oxlint / Stylua |
| ❌ **NO** | **`gcc`** | Toggle line comment |
| ❌ **NO** | **`gc`** *(Visual)* | Toggle block comment |
| ❌ **NO** | **`ss`** | Split window horizontally (`:split`) |
| ❌ **NO** | **`sv`** | Split window vertically (`:vsplit`) |
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
| ❌ **NO** | **`sh`** / **`sj`** / **`sk`** / **`sl`** | Normal | Move focus Left / Down / Up / Right |
| ❌ **NO** | **`te`** | Normal | Open clean tab (`:tabedit`) |
| ❌ **NO** | **`<Tab>`** / **`<S-Tab>`** | Normal | Navigate next / previous tab |
| ❌ **NO** | **`\\`** | Normal | List open buffers and switch |
| ✅ **YES** | **`<Space> + bd`** | Normal | Delete all hidden buffers not displayed in any window |
