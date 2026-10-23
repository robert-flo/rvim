# rvim

Modular and isolated Neovim configuration (`NVIM_APPNAME="rvim"`), based on Craftzdog's high-performance architecture using Neovim 0.12+.

For technical breakdown, data flow, and design decisions, see [ARCHITECTURE.md](ARCHITECTURE.md).

---

## 🚀 Installation & Usage

```bash
# Install or symlink
./install.sh

# Run
rvim
```

---

## ⌨️ Active Keymaps

> **Convention**:
> - `<Leader>` is mapped to Space (`<Space>`).
> - **Direct keys**: Pressed sequentially without Space (e.g., `ss`, `te`, `sh`).

### 🪟 Windows and Tabs Management

| Key | Mode | Action |
| :--- | :---: | :--- |
| `ss` | Normal | Split window horizontally (`:split`) |
| `sv` | Normal | Split window vertically (`:vsplit`) |
| `sh` | Normal | Move focus to left window |
| `sj` | Normal | Move focus to bottom window |
| `sk` | Normal | Move focus to top window |
| `sl` | Normal | Move focus to right window |
| `te` | Normal | Open new tab (`:tabedit`) |
| `<Tab>` | Normal | Next tab |
| `<S-Tab>` | Normal | Previous tab |

### 📝 Editing & Safe Registers (Preserve Clipboard)

| Key | Mode | Action |
| :--- | :---: | :--- |
| `x` | Normal | Delete character into black hole register (`"_x`) |
| `dw` | Normal | Delete word backward without polluting clipboard (`vb"_d`) |
| `<Space> + p` | Normal / Visual | Paste from register `0` (last actual yank, ignores deletions) |
| `<Space> + P` | Normal | Paste before cursor from register `0` |
| `<Space> + c` | Normal / Visual | Change text into black hole register (`"_c`) |
| `<Space> + C` | Normal / Visual | Change to end of line without touching clipboard (`"_C`) |
| `<Space> + d` | Normal / Visual | Delete text into black hole register (`"_d`) |
| `<Space> + D` | Normal / Visual | Delete to end of line without touching clipboard (`"_D`) |
| `<Space> + o` | Normal | Insert line below without auto-continuing comments |
| `<Space> + O` | Normal | Insert line above without auto-continuing comments |
| `+` / `-` | Normal | Increment / decrement number under cursor |
| `<Ctrl> + a` | Normal | Select entire buffer |
| `<Ctrl> + m` | Normal | Jump forward in jumplist |

### 🧰 Helpers and Paths (Bound to `rvim.utils`)

| Key | Mode | Action |
| :--- | :---: | :--- |
| `<Space> + yf` | Normal | Copy relative path with line number (e.g., `src/index.ts:42`) |
| `<Space> + yp` | Normal | Copy absolute path with line number |
| `<Space> + cc` | Visual | Copy selection formatted as Markdown code block |
| `<Space> + j` | Normal | Open `package.json` in floating window |
| `<Space> + bd` | Normal | Close hidden buffers not visible in any window |
| `<Space> + i` | Normal | Toggle LSP inlay hints |
