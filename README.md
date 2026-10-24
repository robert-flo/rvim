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
| ✅ **YES** | **`<Space> + <Space>`** | **Repo Files & Dirs** (Files $\to$ Buffer, Dirs $\to$ Oil.nvim float) |
| ✅ **YES** | **`<Space> + ,`** | **List open buffers** (`Snacks.picker.buffers`) |
| ✅ **YES** | **`<Space> + /`** | **Search History** fuzzy picker (`Snacks.picker.search_history`) |
| ✅ **YES** | **`<Space> + :`** | **Command History** fuzzy picker (`Snacks.picker.command_history`) |
| ✅ **YES** | **`<Space> + x`** | **Save & Quit** all modified buffers (`:xa`) |
| ❌ **NO** | **`;f`** | **Repo Files & Dirs** anchored to repo root (`editor.pick_repo_files_and_dirs`) |
| ❌ **NO** | **`;M`** | **Repo Markdown Files** (`editor.pick_markdown_files`) |
| ❌ **NO** | **`;z`** | **Drive /z/** files & directories (`editor.pick_z_drive`) |
| ❌ **NO** | **`;H`** | **Home ~/** files & directories (`editor.pick_home_dir`) |
| ❌ **NO** | **`;a`** | **Seeker Files** with `<C-e>` toggle to grep (`:Seeker files`) |
| ❌ **NO** | **`;F`** | **Seeker Git Files** (`:Seeker git_files`) |
| ❌ **NO** | **`;G`** | **Seeker Grep** (`:Seeker grep`) |
| ❌ **NO** | **`;W`** | **Seeker Grep Word** under cursor / selection (`:Seeker grep_word`) |
| ❌ **NO** | **`;R`** | **Project Search & Replace** via ripgrep & quickfix (`:Replace`) |
| ❌ **NO** | **`;r`** | **Live Grep** across project text (`Snacks.picker.grep`) |
| ❌ **NO** | **`;s`** | **Document Symbols** / outline fuzzy picker (`Snacks.picker.lsp_symbols`) |
| ❌ **NO** | **`;o`** | **Recent files** picker (`Snacks.picker.recent`) |
| ❌ **NO** | **`sf`** | **Floating file explorer** (`Oil.nvim`) |
| ❌ **NO** | **`\\`** / **`;b`** | **List open buffers** (`Snacks.picker.buffers`) |
| ❌ **NO** | **`;;`** | **Resume** last closed search picker |
| ❌ **NO** | **`;w`** | **Grep word** under cursor (`Snacks.picker.grep_word`) |
| ❌ **NO** | **`;l`** | **Buffer Lines** search in active file (`Snacks.picker.lines`) |
| ❌ **NO** | **`;m`** | **Git Status** modified files picker (`Snacks.picker.git_status`) |
| ❌ **NO** | **`;g`** | **Open Lazygit** in integrated floating terminal |
| ✅ **YES** | **`<Space> + u`** | **Undo History** visual tree picker (`Snacks.picker.undo`) |
| ✅ **YES** | **`<Space> + ?`** | **Help Documentation** tags picker (`Snacks.picker.help`) |
| ❌ **NO** | **`<Ctrl> + s`** | **Quick save** file from any mode (Normal, Insert, Visual) |
| ❌ **NO** | **`<Esc>`** | **Clear search highlights** (`nohlsearch`) |
| ✅ **YES** | **`<Space> + f`** | **Format code** with Conform (Prettier / Ktlint / Clang / Stylua) |
| ❌ **NO** | **`gcc`** | Toggle line comment |
| ❌ **NO** | **`gc`** *(Visual)* | Toggle block comment |
| ❌ **NO** | **`ss`** | Split window horizontally (`:split`) |
| ❌ **NO** | **`sv`** | Split window vertically (`:vsplit`) |
| ✅ **YES** | **`<Space> + sa`** | **AutoTile split** window according to aspect ratio (`:AutoTile`) |
| ✅ **YES** | **`<Space> + se`** | Equalize all split window dimensions (`<C-w>=`) |
| ✅ **YES** | **`<Space> + sx`** | Close current split window (`:close`) |
| ❌ **NO** | **`sh`** / **`sj`** / **`sk`** / **`sl`** | Focus window Left / Down / Up / Right |
| ❌ **NO** | **`te`** | Open new clean tab (`:tabedit`) |
| ❌ **NO** | **`<Tab>`** / **`<S-Tab>`** | Switch to next / previous tab |
| ❌ **NO** | **`[x`** / **`]x`** | Jump to previous / next **Git merge conflict marker** |
| ❌ **NO** | **`[<space>`** / **`]<space>`** | Insert blank line above / below cursor without moving |

---

### 🔍 1.1 Pickers Suite (`<Space> + ;`) & Express Shortcuts (`;*`)

#### 🎯 The Two-Tier Architecture

```text
┌─────────────────────────────────────────────────────────────────┐
│  Tier 1: Interactive Discovery Hub (Which-Key)                  │
│  <Space> + ;                                                    │
│  → Visual, documented, colored, and grouped under " Pickers"   │
└─────────────────────────────────┬───────────────────────────────┘
                                  │ 1:1 Key & Function Parity
┌─────────────────────────────────▼───────────────────────────────┐
│  Tier 2: Express Muscle-Memory Shortcuts                        │
│  Direct ;* (e.g. ;f, ;r, ;s, ;b, ;w, \\)                        │
│  → Instant 2-key execution without pressing Space               │
└─────────────────────────────────────────────────────────────────┘
```

#### 📋 Complete Parity Matrix

Every single action in the Pickers suite shares the identical key mnemonic between Which-Key and the direct shortcut:

| Which-Key (`<Space> + ;`) | Express Shortcut | Action | Description |
| :--- | :---: | :--- | :--- |
| **`<Space> + ;;`** | **`;;`** | **Resume Picker** | Reopens last closed search picker session |
| **`<Space> + ;b`** | **`;b`** / **`\\`** | **List Buffers** | Fuzzy search open buffers (jumps to existing window) |
| **`<Space> + ;c`** | **`;c`** | **Incoming Calls** | LSP incoming call hierarchy |
| **`<Space> + ;e`** | **`;e`** | **Diagnostics** | Project diagnostic errors and warnings |
| **`<Space> + ;f`** | **`;f`** | **Repo Files & Dirs** | Search repo root; opens files in buffer or dirs in floating Oil.nvim |
| **`<Space> + ;M`** | **`;M`** | **Repo Markdown** | Search all `.md` and `.markdown` files anchored to repo root |
| **`<Space> + ;z`** | **`;z`** | **Drive /z/** | Search all files and directories across `/z/` with Oil integration |
| **`<Space> + ;H`** | **`;H`** | **Home ~/** | Search all files and directories across `$HOME` with Oil integration |
| **`<Space> + ;a`** | **`;a`** | **Seeker Files** | File search with instant `<C-e>` bidirectional toggle to ripgrep |
| **`<Space> + ;F`** | **`;F`** | **Seeker Git Files** | Git-tracked file search with Seeker mode toggling |
| **`<Space> + ;G`** | **`;G`** | **Seeker Grep** | Ripgrep search with instant `<C-e>` toggle back to file list |
| **`<Space> + ;W`** | **`;W`** | **Seeker Grep Word** | Seeker search for word under cursor or visual selection |
| **`<Space> + ;R`** | **`;R`** | **Search & Replace** | Interactive project-wide find and replace (`:Replace`) |
| **`<Space> + ;g`** | **`;g`** | **Lazygit** | Launch integrated floating Lazygit terminal |
| **`<Space> + ;h`** | **`;h`** | **Git Diff Hunks** | Interactive Git diff hunks picker |
| **`<Space> + ;n`** | **`;n`** | **Notifications** | View Snacks notification history |
| **`<Space> + ;o`** | **`;o`** | **Recent Files** | Search recently opened files |
| **`<Space> + ;r`** | **`;r`** | **Live Grep** | Search project text with ripgrep (`Snacks.picker.grep`) |
| **`<Space> + ;s`** | **`;s`** | **Document Symbols** | Fuzzy search functions, variables, classes |
| **`<Space> + ;w`** | **`;w`** | **Grep Word** | Grep word under cursor across repository |
| **`<Space> + ;l`** | **`;l`** | **Buffer Lines** | Fuzzy search text within current file |
| **`<Space> + ;m`** | **`;m`** | **Git Status** | List modified/staged files with live diff preview |
| **`<Space> + ;C`** | **`;C`** | **Commands** | Fuzzy search and run Neovim & plugin commands |
| **`<Space> + ;u`** | **`;u`** | **Undo History** | Visual interactive undo tree explorer |
| **`<Space> + ;?`** | **`;?`** | **Help Tags** | Fuzzy search official Neovim documentation |

#### 🎨 Visual Layout in Which-Key

```text
                Pickers
; → Resume Picker       M → Repo Markdown Files
a → Seeker Files        o → Recent Files
b → List Buffers        r → Live Grep
c → Incoming Calls      R → Project Search & Replace
C → Commands            s → Document Symbols
e → Diagnostics         u → Undo History
f → Repo Files & Dirs   w → Grep Word
F → Seeker Git Files    W → Seeker Grep Word
g → Lazygit             z → Drive /z/ (Files & Dirs)
G → Seeker Grep         H → Home ~/ (Files & Dirs)
h → Git Diff Hunks      ? → Help Tags
l → Buffer Lines
m → Git Status
n → Notifications
```

---

### 🚀 1.2 Express Root Actions (`<Space>` + Single Key)

High-productivity single-stroke actions accessible directly at the root of Which-Key:

| Keymap | Which-Key Label | Action | Description |
| :--- | :---: | :--- | :--- |
| **`<Space> + <Space>`** | `🚀 Repo Files & Dirs` | **Repo Files & Dirs** | Search repo root files & dirs (Dirs $\to$ Oil float, Files $\to$ Buffer) |
| **`<Space> + ,`** | `, Buffers` | **Open Buffers** | Ergonomic right-hand buffer picker (`Snacks.picker.buffers`) |
| **`<Space> + /`** | `/ Search History` | **Search History** | Interactive fuzzy search of past search patterns (`Snacks.picker.search_history`) |
| **`<Space> + :`** | `: Command History` | **Command History** | Interactive fuzzy search of recent `:` commands (`Snacks.picker.command_history`) |
| **`<Space> + x`** | `x Save and Quit` | **Save & Quit** | Write all modified buffers and exit Neovim (`:xa<CR>`) |
| **`<Space> + f`** | `f Format Code` | **Format Buffer** | Format active file with Conform (`require("conform").format()`) |
| **`<Space> + j`** | `j Open package.json` | **Package.json** | Open project `package.json` in centered floating modal |
| **`<Space> + C`** / **`D`** | `C / D Change/Delete EOL` | **Change / Delete to EOL** | Modify or delete to end of line into black hole register (`"_`) |
| **`<Space> + p`** / **`P`** | `p / P Paste` | **Safe Paste** | Paste from register `0`, immune to deletions |
| **`<Space> + o`** / **`O`** | `o / O Clean Line` | **Clean Line** | Insert new line above/below without continuing comments |
| **`<Space> + u`** | `u Undo History` | **Undo Tree** | Visual interactive undo tree history (`Snacks.picker.undo`) |
| **`<Space> + ?`** | `? Help Tags` | **Help Docs** | Search Neovim documentation tags (`Snacks.picker.help`) |

---

### 📝 2. Editing & Safe Clipboard Registers

| Space? | Keymap | Mode | Action |
| :---: | :--- | :---: | :--- |
| ✅ **YES** | **`<Space> + p`** | Normal / Visual | **Paste last yank**: uses register `0`, ignoring deletions with `d` or `x` |
| ✅ **YES** | **`<Space> + P`** | Normal | Paste before cursor from register `0` |
| ✅ **YES** | **`<Space> + C`** | Normal / Visual | Change to end of line into black hole register (`"_C`) |
| ✅ **YES** | **`<Space> + D`** | Normal / Visual | Delete to end of line into black hole register (`"_D`) |
| ✅ **YES** | **`<Space> + c`** | Visual | Change text into black hole register (`"_c`) without overwriting clipboard |
| ✅ **YES** | **`<Space> + d`** | Visual | Delete text into black hole register (`"_d`) |
| ✅ **YES** | **`<Space> + o`** | Normal | Insert clean line below without auto-continuing comments |
| ✅ **YES** | **`<Space> + O`** | Normal | Insert clean line above without auto-continuing comments |
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

### 📋 2.1 Yank & Path Clipboard Suite (`<Space> + y`)

Comprehensive clipboard operations integrated with WhichKey and user commands:

| Space? | Keymap | Mode | User Command | Description |
| :---: | :--- | :---: | :--- | :--- |
| ✅ **YES** | **`<Space> + ya`** | Normal | `:%y+` | **Copy Whole File** into clipboard register `+` |
| ✅ **YES** | **`<Space> + yd`** | Normal | `:CopyFileDirectory` | **File Directory** path with trailing slash (e.g. `/z/repo/`) |
| ✅ **YES** | **`<Space> + yf`** | Normal | `:CopyFileName` | **File Name** (e.g. `which-key.lua`) |
| ✅ **YES** | **`<Space> + yg`** | Normal / Visual | `:CopyGitUrl` | **Copy Git URL** with remote, branch, relative path, and `#L<line>` or `#L<start>-L<end>` |
| ✅ **YES** | **`<Space> + yl`** | Normal | `:CopyRelativePathWithLine` | **Relative Path with Line** (e.g. `lua/rvim/plugins/which-key.lua:42`) |
| ✅ **YES** | **`<Space> + yL`** | Normal | `:CopyAbsolutePathWithLine` | **Absolute Path with Line** (e.g. `/path/to/project/file.lua:42`) |
| ✅ **YES** | **`<Space> + yp`** | Normal | `:CopyRelativePath` | **Relative Path** |
| ✅ **YES** | **`<Space> + yP`** | Normal | `:CopyAbsolutePath` | **Absolute Path** |

---

### 🧠 3. LSP, Diagnostics & Code Intelligence (`<Space> + c`)

Complete Code Intelligence suite integrated into Which-Key under `<Space> + c`:

| Space? | Keymap | Mode | Action |
| :---: | :--- | :---: | :--- |
| ✅ **YES** | **`<Space> + ca`** | Normal / Visual | **Code Actions** (Quick fixes, refactors) |
| ✅ **YES** | **`<Space> + cf`** *(or `<Space> + f`)* | Normal / Visual | **Format Code** with Conform (Prettier / Ktlint / Clang / Stylua) |
| — | **`:ToggleFormatter`** | Command | Toggle automatic code formatting on save for active buffer |
| ✅ **YES** | **`<Space> + cr`** | Normal | **Rename symbol** across whole project (*LSP Rename*) |
| ✅ **YES** | **`<Space> + cR`** | Normal | Rename file on disk and update imports automatically |
| ✅ **YES** | **`<Space> + cm`** | Normal | **Markdown Live Preview** in web browser without external server (`:MDPreview`) |
| ✅ **YES** | **`<Space> + cM`** | Normal | **Toggle Markdown Render** in active buffer (`:RenderMarkdown toggle`) |
| ✅ **YES** | **`<Space> + ce`** | Normal / Visual | **Execute Code** buffer or visual selection (`:Runner`) |
| ✅ **YES** | **`<Space> + cp`** | Normal | **Project Search & Replace** with Ripgrep & Quickfix (`:Replace`) |
| ✅ **YES** | **`<Space> + cD`** | Normal | **Set Root Directory** to detected Git root (`:RootDir`) |
| ✅ **YES** | **`<Space> + cc`** | Normal | Run CodeLens under cursor |
| ✅ **YES** | **`<Space> + cC`** | Normal | Refresh CodeLens in buffer |
| ✅ **YES** | **`<Space> + cd`** | Normal | Show line diagnostics floating window |
| ✅ **YES** | **`<Space> + ci`** | Normal | Toggle LSP inlay hints |
| ✅ **YES** | **`<Space> + cl`** | Normal | Show active LSP servers information |
| ❌ **NO** | **`gd`** | Normal | **Goto definition** under cursor (`Snacks.picker.lsp_definitions`) |
| ❌ **NO** | **`gD`** | Normal | Goto declaration |
| ❌ **NO** | **`gy`** | Normal | Goto type definition |
| ❌ **NO** | **`gr`** | Normal | Find all references |
| ❌ **NO** | **`gI`** | Normal | Goto source definition / implementation |
| ❌ **NO** | **`K`** | Normal | Display hover documentation |
| ❌ **NO** | **`gK`** | Normal | Display signature help |
| ❌ **NO** | **`<Ctrl> + k`** | Insert | Show function arguments popup while typing |
| ❌ **NO** | **`<Ctrl> + j`** | Normal | Jump to next error or diagnostic in buffer |
| ❌ **NO** | **`;s`** / **`<Space> + ;s`** | Normal | **Document Symbols** picker (functions, classes, methods) |
| ❌ **NO** | **`;o`** / **`<Space> + ;o`** | Normal | **Recent files** picker |
| ❌ **NO** | **`;e`** / **`<Space> + ;e`** | Normal | List all diagnostics across project |
| ❌ **NO** | **`;c`** / **`<Space> + ;c`** | Normal | List incoming calls to function under cursor |
| ❌ **NO** | **`]]`** / **`[[`** | Normal | Jump to next / previous reference of symbol under cursor |

---

### 🌿 4. Git & Version Control (`which-key` `<Space> + g`)

Pressing `<Space> + g` opens an interactive centered popup menu powered by `which-key.nvim`:

| Space? | Keymap | Mode | Action |
| :---: | :--- | :---: | :--- |
| ✅ **YES** | **`<Space> + ga`** | Normal / Visual | **Stage Hunk** (`Gitsigns`) |
| ✅ **YES** | **`<Space> + gA`** | Normal | **Stage Buffer** (`Gitsigns`) |
| ✅ **YES** | **`<Space> + gb`** | Normal | **Blame Line** with full author and commit info |
| ✅ **YES** | **`<Space> + gB`** | Normal | **Git Branches** picker & checkout (`Snacks.picker`) |
| ✅ **YES** | **`<Space> + gc`** | Normal | **Commit Staged** in floating terminal |
| ✅ **YES** | **`<Space> + gC`** | Normal | **Co-Authors** picker (`co-author.nvim` + `Snacks.picker`) |
| ✅ **YES** | **`<Space> + gd`** | Normal | **Git Diff** against HEAD (`Gitsigns`) |
| ✅ **YES** | **`<Space> + gf`** | Normal | **File Commits** history picker (`Snacks.picker`) |
| ✅ **YES** | **`<Space> + gg`** | Normal | **Launch Lazygit** |
| ✅ **YES** | **`<Space> + gi`** | Normal | **Hunk Info** / preview floating window |
| ✅ **YES** | **`<Space> + gj`** | Normal | Jump to **Next Hunk** |
| ✅ **YES** | **`<Space> + gk`** | Normal | Jump to **Prev Hunk** |
| ✅ **YES** | **`<Space> + gl`** | Normal | **Line Commits** history picker (`Snacks.picker`) |
| ✅ **YES** | **`<Space> + gL`** | Normal | **Git Commit Log** repository history (`Snacks.picker`) |
| ✅ **YES** | **`<Space> + gr`** | Normal / Visual | **Reset Hunk** (`Gitsigns`) |
| ✅ **YES** | **`<Space> + gR`** | Normal | **Reset Buffer** (`Gitsigns`) |
| ✅ **YES** | **`<Space> + gs`** | Normal | **Git Status** modified/staged files picker (`Snacks.picker`) |
| ✅ **YES** | **`<Space> + gS`** | Normal | **Git Stash** picker (`Snacks.picker`) |
| ✅ **YES** | **`<Space> + gu`** | Normal / Visual | **Undo Stage Hunk** (`Gitsigns`) |
| ✅ **YES** | **`<Space> + gv`** | Normal | **Select Hunk** visual range (`Gitsigns`) |
| ✅ **YES** | **`<Space> + gw`** | Normal | **Git Browse** repository / file on web (`Snacks.gitbrowse`) |
| ❌ **NO** | **`;m`** | Normal | Direct shortcut to modified files picker (`git_status`) |
| ❌ **NO** | **`;g`** | Normal | Direct shortcut to launch Lazygit |
| ❌ **NO** | **`;h`** | Normal | Direct shortcut to interactive Git hunks picker |
| ❌ **NO** | **`]c`** / **`[c`** | Normal | Jump to next / previous git diff hunk in file |

#### 🌐 GitHub Submenu (`<Space> + gh`)
| Keymap | Action |
| :--- | :--- |
| **`<Space> + ghi`** | GitHub Issues (open) fuzzy picker |
| **`<Space> + ghI`** | GitHub Issues (all) fuzzy picker |
| **`<Space> + ghp`** | GitHub Pull Requests (open) fuzzy picker |
| **`<Space> + ghP`** | GitHub Pull Requests (all) fuzzy picker |

#### 🎚️ Git Toggles Submenu (`<Space> + gt`)
| Keymap | Action |
| :--- | :--- |
| **`<Space> + gtb`** | Toggle virtual line blame |
| **`<Space> + gtd`** | Toggle deleted lines view |
| **`<Space> + gtl`** | Toggle line highlight |
| **`<Space> + gtn`** | Toggle number highlight |
| **`<Space> + gts`** | Toggle signs in signcolumn |
| **`<Space> + gtw`** | Toggle word diff |

---

###  4.1 Diff Suite (`<Space> + d`)

Full two-pane code comparison and commit history explorer powered by `codediff.nvim`:

| Space? | Keymap | Mode | User Command | Description |
| :---: | :--- | :---: | :--- | :--- |
| ✅ **YES** | **`<Space> + dv`** | Normal | `:CodeDiff` | **Toggle CodeDiff** interactive two-pane diff viewer |
| ✅ **YES** | **`<Space> + dh`** | Normal | `:CodeDiff history %` | **File History** Git commit revisions for current file |
| ✅ **YES** | **`<Space> + dH`** | Normal | `:CodeDiff history` | **Repo History** Git commit revisions across repository |

---

### 🏠 5. Startup Dashboard (`Snacks.dashboard`)

When launched with an empty buffer (`rvim`), an interactive dashboard opens with one-key quick actions, recent files, and projects:

| Key | Action |
| :---: | :--- |
| **`f`** | **Find files** in project (`;f`) |
| **`n`** | **New file** in clean buffer and enter insert mode |
| **`r`** | **Live Grep** across project text (`;r`) |
| **`o`** | **Recent files** picker (`;o`) |
| **`g`** | **Open Lazygit** in integrated floating terminal (`;g`) |
| **`c`** | **Browse configuration** files (`~/.config/rvim`) |
| **`q`** | **Quit** Neovim |

---

### 🔍 6. Inside Pickers (`Snacks.picker`)

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

### 📂 7. Inside File Explorer (`Oil.nvim` with `sf`)

| Keymap | Action |
| :--- | :--- |
| **`<Enter>`** | Open file or enter directory |
| **`h`** | Go to parent directory |
| **`q`** | Close file explorer |
| **`:w`** | Save changes (rename, move, or delete files directly as buffer text) |

---

### 🤖 8. GitHub Copilot & Autocomplete (`blink.cmp`)

| Space? | Keymap | Mode | Action |
| :---: | :--- | :---: | :--- |
| ❌ **NO** | **`<Enter>`** or **`<Ctrl> + y`** | Insert | Accept autocomplete popup suggestion (`blink.cmp`) |
| ❌ **NO** | **`<Ctrl> + l`** | Insert | Accept full Copilot ghost text suggestion |
| ❌ **NO** | **`<Alt> + l`** | Insert | Accept next word from Copilot suggestion |
| ❌ **NO** | **`<Alt> + Shift + l`** | Insert | Accept next line from Copilot suggestion |
| ❌ **NO** | **`<Alt> + ]`** / **`<Alt> + [`** | Insert | Cycle to next / previous Copilot suggestion |
| ❌ **NO** | **`<Ctrl> + ]`** | Insert | Dismiss Copilot suggestion |

---

### 🪟 9. Windows, Tabs & Buffers

Comprehensive window management, split controls, tabs, and buffer operations with full Which-Key integration:

#### 󰈔 Buffers Suite (`<Space> + b`)
| Keymap | Direct Shortcut | Action | Description |
| :--- | :---: | :--- | :--- |
| **`<Space> + bb`** | **`\\`** / **`;b`** | **List Buffers** | Fuzzy search open buffers and switch |
| **`<Space> + bd`** | — | **Delete Hidden Buffers** | Close all unlisted/hidden buffers with unsaved-change protection |
| **`<Space> + bx`** | — | **Close Current Buffer** | Close active buffer (`:bdelete`) |
| **`<Space> + bo`** | — | **Close Other Buffers** | Close all buffers except current (`:%bd\|e#\|bd#`) |

####  Split / Window Suite (`<Space> + s`)
| Keymap | Direct Shortcut | Action | Description |
| :--- | :---: | :--- | :--- |
| **`<Space> + ss`** | **`ss`** | **Horizontal Split** | Split window horizontally (`:split`) |
| **`<Space> + sv`** | **`sv`** | **Vertical Split** | Split window vertically (`:vsplit`) |
| **`<Space> + sa`** | — | **AutoTile Split** | Dynamically split window horizontally/vertically by aspect ratio (`:AutoTile`) |
| **`<Space> + se`** | — | **Equalize Splits** | Equalize all split dimensions (`<C-w>=`) |
| **`<Space> + sx`** | — | **Close Split** | Close current split window (`:close`) |
| **`<Space> + sh`** | **`sh`** | **Focus Left** | Move focus to left split (`<C-w>h`) |
| **`<Space> + sj`** | **`sj`** | **Focus Down** | Move focus to lower split (`<C-w>j`) |
| **`<Space> + sk`** | **`sk`** | **Focus Up** | Move focus to upper split (`<C-w>k`) |
| **`<Space> + sl`** | **`sl`** | **Focus Right** | Move focus to right split (`<C-w>l`) |
| **`<Space> + so`** | — | **Close Others** | Close all other split windows (`<C-w>o`) |

#### 󰓩 Tabs Suite (`<Space> + t`)
| Keymap | Direct Shortcut | Action | Description |
| :--- | :---: | :--- | :--- |
| **`<Space> + te`** | **`te`** | **New Tab** | Open a new clean tab (`:tabedit`) |
| **`<Space> + tx`** | — | **Close Tab** | Close active tab (`:tabclose`) |
| **`<Space> + tl`** | **`<Tab>`** | **Next Tab** | Switch to next tab (`:tabnext`) |
| **`<Space> + th`** | **`<S-Tab>`** | **Previous Tab** | Switch to previous tab (`:tabprev`) |

#### 󰉋 Explorer & Files Suite (`<Space> + e`)
| Keymap | Direct Shortcut | Action | Description |
| :--- | :---: | :--- | :--- |
| **`<Space> + ee`** | **`sf`** | **File Explorer** | Open Oil floating file explorer with preview |
| **`<Space> + em`** | **`;M`** | **Repo Markdown** | Search all `.md` and `.markdown` files anchored to repo root |
| **`<Space> + ez`** | **`;z`** | **Drive /z/** | Search all files and directories across `/z/` with Oil integration |
| **`<Space> + eh`** | **`;H`** | **Home ~/** | Search all files and directories across `$HOME` with Oil integration |
| **`<Space> + er`** | — | **Ranger Picker** | Open floating Ranger file manager (`:RangerPicker`) |
| **`<Space> + ep`** | **`<Space> + j`** | **Package.json** | Open project `package.json` in centered 80% floating window |
| **`<Space> + en`** | — | **New File** | Open a new empty buffer (`:enew`) |
| **`<Space> + es`** | **`<Ctrl> + s`** | **Save File** | Save active buffer immediately (`:w`) |

---

### 📱 10. Language Support & Toolchains

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

---

### 🐙 11. GitHub & Repositories (`Octohub.nvim`)

rvim integrates [`octohub.nvim`](https://github.com/2kabhishek/octohub.nvim) alongside [`utils.nvim`](https://github.com/2kabhishek/utils.nvim) and [`pickme.nvim`](https://github.com/2kabhishek/pickme.nvim), delegating UI picker queries directly to `Snacks.picker`:

> 🔑 **Requirement**: Requires the GitHub CLI tool (`gh`) authenticated with `gh auth login`.

| Space? | Keymap | Action |
| :---: | :--- | :--- |
| ✅ **YES** | **`<Space> + goo`** | **Browse & clone all repositories** in interactive fuzzy picker |
| ✅ **YES** | **`<Space> + gos`** | Repositories sorted by **stars** |
| ✅ **YES** | **`<Space> + gou`** | Repositories sorted by **last updated** |
| ✅ **YES** | **`<Space> + goU`** | Repositories sorted by **last pushed** |
| ✅ **YES** | **`<Space> + goc`** | Repositories sorted by **creation date** |
| ✅ **YES** | **`<Space> + gof`** | Repositories sorted by **forks** |
| ✅ **YES** | **`<Space> + goi`** | Repositories sorted by **open issues** |
| ✅ **YES** | **`<Space> + gol`** | Repositories sorted by **language** |
| ✅ **YES** | **`<Space> + gob`** | Repositories sorted by **size** |
| ✅ **YES** | **`<Space> + goA`** | Show only **archived** repositories |
| ✅ **YES** | **`<Space> + goF`** | Show only **forked** repositories |
| ✅ **YES** | **`<Space> + goP`** | Show only **private** repositories |
| ✅ **YES** | **`<Space> + goS`** | Show only **starred** repositories |
| ✅ **YES** | **`<Space> + goT`** | Show only **template** repositories |
| ✅ **YES** | **`<Space> + goL`** | Interactive **language filter picker** |
| ✅ **YES** | **`<Space> + gog`** | View **GitHub contribution graph** popup |
| ✅ **YES** | **`<Space> + goa`** | View **recent GitHub activity** |
| ✅ **YES** | **`<Space> + gor`** | View **current repository statistics** |
| ✅ **YES** | **`<Space> + got`** | View **complete profile & repository stats** |
| ✅ **YES** | **`<Space> + gow`** | Open current repository on GitHub in web browser |
| ✅ **YES** | **`<Space> + gop`** | Open authenticated user's profile in web browser |

---

### 🛠️ 12. Seeker & Homegrown Plugins Suite

rvim integrates [`seeker.nvim`](https://github.com/2kabhishek/seeker.nvim) and [`homegrown.nvim`](https://github.com/2kabhishek/homegrown.nvim) to provide seamless search transitions and high-performance native editor extensions without external daemon dependencies:

#### 🔍 Seeker: Bidirectional File & Grep Bridge
- **Instant Search Mode Switching**: When searching files in `:Seeker files` or `:Seeker git_files`, press `<Ctrl> + e` to immediately transition to ripgrep scoped exclusively to the matched files (`toggle_to_grep`). Press `<Ctrl> + e` again in grep mode to jump back to the file list (`toggle_to_file`).
- **Exclude Filter**: Press `<Ctrl> + x` to toggle excluding highlighted files from the search set.

| Keymap | Shortcut | Action | Description |
| :--- | :---: | :--- | :--- |
| **`<Space> + ;a`** | **`;a`** | **Seeker Files** | File search with instant `<C-e>` toggle to ripgrep |
| **`<Space> + ;F`** | **`;F`** | **Seeker Git Files** | Git-tracked file search with Seeker mode toggling |
| **`<Space> + ;G`** | **`;G`** | **Seeker Grep** | Live grep search with instant `<C-e>` toggle back to file list |
| **`<Space> + ;W`** | **`;W`** | **Seeker Grep Word** | Grep word under cursor or visual selection |

#### 🌿 Homegrown: Lightweight Editor Utilities
- **`:MDPreview` (`<Space> + cm`)**: Browser-based real-time markdown preview without Node.js or external servers. Automatically creates a standalone bundle in `/tmp/nvim_md/` and live-syncs on `TextChanged` and `TextChangedI`.
- **`:Runner` (`<Space> + ce`)**: Asynchronous code execution for active buffer or visual selection (`lua`, `vim`, `python`, `node`, `ts-node`, `bash`, `go`, `ruby`, `elixir`, `java`).
- **`:AutoTile` (`<Space> + sa`)**: Smart autotiling split that evaluates the active window's aspect ratio (`width >= height * 2.0` $\to$ vertical split, otherwise horizontal split).
- **`:Replace` (`<Space> + cp` / `;R`)**: Project-wide search and replace using Ripgrep and Quickfix with interactive confirmation modes (`cfdo %s/.../.../g | update`).
- **`:RootDir` (`<Space> + cD`)**: Automatically changes the current buffer window directory (`lcd`) to the Git repository root.
- **`:RangerPicker` (`<Space> + er`)**: Opens the Ranger file manager in a centered floating window powered by `Snacks.terminal`.
- **Conflict & Line Motions**:
  - **`[x` / `]x`**: Instantly jump to the previous / next Git merge conflict marker (`<<<<<<<`, `=======`, `>>>>>>>`).
  - **`[<space>` / `]<space>`**: Insert blank line above / below cursor without moving the cursor.

---

### 🎨 13. Markdown Rendering & Notes Suite (`render-markdown.nvim`)

rvim integrates [`render-markdown.nvim`](https://github.com/MeanderingProgrammer/render-markdown.nvim) to transform raw Markdown source code into formatted, beautifully rendered documents inside Neovim buffers and picker previews:

#### ⚡ Highlights & Rendering Capabilities
- **Picker Preview Integration**: Works seamlessly with `Snacks.picker.files` (`<Space>em` / `;M`). Preview windows automatically disable line numbers (`number = false`), enable line wrapping (`wrap = true`), and enforce concealment (`conceallevel = 2`) so markdown notes preview like rendered pages rather than raw source code.
- **Obsidian & GitHub Callouts**: Renders all standard callout blocks (`> [!NOTE]`, `> [!TIP]`, `> [!WARNING]`, `> [!IMPORTANT]`, `> [!CAUTION]`, `> [!BUG]`, `> [!EXAMPLE]`, `> [!QUOTE]`) into styled, colored alert boxes with icons.
- **Header Badges**: Hides raw `#` characters and displays styled heading level icons (`󰲡`, `󰲣`, `󰲥`, `󰲧`, `󰲩`, `󰲫`) with colored accent banners.
- **Unicode Tables**: Formats pipe tables with clean Unicode box-drawing borders (`┌─┬─┐`, `│ │ │`, `└─┴─┘`).
- **Interactive Checkboxes**: Converts `- [ ]` and `- [x]` into visual checkbox icons (`󰄱`, `󰄲`).
- **Clean Bullets & Code Blocks**: Renders multi-level bullet points (`●`, `○`, `◆`) and shaded code block containers.

| Keymap | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| **`<Space> + cM`** | Normal | **Toggle Markdown Render** | Toggle between rendered and raw markdown in active buffer (`:RenderMarkdown toggle`) |
| **`<Space> + cm`** | Normal | **Markdown Live Preview** | Open live-sync preview in web browser (`:MDPreview`) |



