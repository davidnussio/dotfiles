# 📋 Cheatsheet

> Quick reference for keybindings, aliases, abbreviations, and CLI tools.

---

## ⌨️ Shell Keybindings (Fish + fzf)

| Keybinding | Action |
| :--- | :--- |
| `Ctrl+T` | Fuzzy find files |
| `Ctrl+R` | Fuzzy search command history |
| `Alt+C` | `cd` into directory (fuzzy) |
| `Alt+Shift+C` | `cd` into directory (fuzzy, include hidden) |
| `Alt+G` | Open file with default app |
| `Alt+O` | Open file in `$EDITOR` |
| `Alt+←` / `Alt+↑` | Go to previous directory |
| `Alt+→` | Go to next directory |
| `...` | Expands to `../..` (and so on) |

---

## 🐟 Fish Abbreviations & Aliases

### General

| Abbr / Alias | Expands to | Description |
| :--- | :--- | :--- |
| `n` / `vi` / `vim` | `nvim` | Open Neovim |
| `o` | `open` | Open file/dir with macOS |
| `reload` | `exec $SHELL -l` | Reload shell |
| `fsource` | `source ~/.config/fish/config.fish` | Reload fish config |
| `efish` | `nvim ~/.config/fish/config.fish` | Edit fish config |
| `e` | `envsec` | Manage env secrets |
| `tw` | `timew` | Timewarrior time tracking |
| `playground` | `cd ~/Developer/playground && code .` | Jump to playground |

### File System

| Alias | Command | Description |
| :--- | :--- | :--- |
| `ls` | `eza` | List files |
| `lsa` | `eza -a` | List all (including hidden) |
| `ll` | `eza -lh --group-directories-first --icons` | Long list with icons |
| `lla` | `ll -a` | Long list, all files |
| `lt` | `eza --tree --level=2 --long --icons --git` | Tree view (2 levels) |
| `lta` | `lt -a` | Tree view, all files |
| `cat` | `bat --plain` | Syntax-highlighted cat |
| `catl` | `bat` | Cat with line numbers |
| `ff` | `fzf --preview 'bat ...'` | Fuzzy find with preview |
| `fd` | `fdfind` | Fast file finder |
| `lst` | `tree -a -I "node_modules\|.git\|..."` | Tree, ignoring noise |
| `agi` | `ag --ignore node_modules ...` | Silver searcher, no noise |

### Git Abbreviations

| Abbr | Expands to | Description |
| :--- | :--- | :--- |
| `g` | `git` | Git |
| `ga` | `git add` | Stage files |
| `gc` | `git commit` | Commit |
| `gs` | `git status` | Status |
| `gd` | `git diff` | Diff |
| `gl` | `git lg` | Pretty log graph |
| `gco` | `git checkout` | Checkout |
| `gcb` | `git checkout -b` | New branch |
| `gcm` | `git checkout master` | Checkout master |
| `gbb` | `git checkout -` | Previous branch |
| `gpu` | `git push` | Push |
| `gpl` | `git stash -u && git pull --rebase && git stash pop` | Safe pull with stash |
| `git-clean-branches` | `git fetch --prune && git gc` | Prune dead branches |

---

## 🔧 Git Aliases (`.gitconfig`)

| Alias | Description |
| :--- | :--- |
| `git lg` | Pretty graph log (relative dates) |
| `git lg2` | Pretty graph log (absolute dates) |
| `git last` | Files changed in last commit |
| `git undo` | Undo last commit (keep changes staged) |
| `git save <msg>` | `git stash push -m <msg>` |
| `git current` | Print current branch name |
| `git hide <file>` | `assume-unchanged` a file |
| `git unhide <file>` | Remove `assume-unchanged` |
| `git hidden` | List all hidden files |
| `git ignore <lang>` | Fetch `.gitignore` from gitignore.io |

---

## 🛠 CLI Tools Reference

### Navigation & Files

| Tool | Purpose | Key usage |
| :--- | :--- | :--- |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart `cd` with frecency | `z <partial-path>` |
| [yazi](https://github.com/sxyazi/yazi) | Terminal file manager | `yazi` |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder | `Ctrl+T`, `Ctrl+R`, `Alt+C` |
| [fd](https://github.com/sharkdp/fd) | Fast `find` replacement | `fd <pattern>` |
| [eza](https://github.com/eza-community/eza) | Modern `ls` | `ll`, `lt` |
| [bat](https://github.com/sharkdp/bat) | `cat` with syntax highlight | `cat`, `catl` |

### Search & Data

| Tool | Purpose | Key usage |
| :--- | :--- | :--- |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast `grep` | `rg <pattern>` |
| [jq](https://jqlang.github.io/jq/) | JSON processor | `jq '.'` |
| [gron](https://github.com/tomnomnom/gron) | Make JSON greppable | `gron file.json \| grep foo` |
| [fx](https://github.com/antonmedv/fx) | Interactive JSON viewer | `fx file.json` |
| [miller](https://miller.readthedocs.io) | CSV/JSON/TSV swiss army knife | `mlr --csv filter '...'` |

### HTTP & API

| Tool | Purpose | Key usage |
| :--- | :--- | :--- |
| [xh](https://github.com/ducaale/xh) | Fast HTTPie-like client | `xh GET httpbin.org/get` |
| [hurl](https://hurl.dev) | Declarative HTTP testing | `hurl test.hurl` |
| [oha](https://github.com/hatoo/oha) | HTTP load testing | `oha -n 1000 http://...` |

### Git

| Tool | Purpose | Key usage |
| :--- | :--- | :--- |
| [lazygit](https://github.com/jesseduffield/lazygit) | TUI git client | `lazygit` |
| [delta](https://github.com/dandavison/delta) | Beautiful diffs | auto via `core.pager` |

### Kubernetes

| Tool | Purpose | Key usage |
| :--- | :--- | :--- |
| [k9s](https://k9scli.io) | TUI for kubectl | `k9s` |
| [kubectx](https://github.com/ahmetb/kubectx) | Switch contexts | `kubectx`, `kubens` |
| [stern](https://github.com/stern/stern) | Multi-pod log tailing | `stern <pod-regex>` |
| [helm](https://helm.sh) | Kubernetes package manager | `helm install ...` |

### Dev Utilities

| Tool | Purpose | Key usage |
| :--- | :--- | :--- |
| [hyperfine](https://github.com/sharkdp/hyperfine) | Shell benchmarking | `hyperfine 'cmd1' 'cmd2'` |
| [viddy](https://github.com/sachaos/viddy) | Modern `watch` with diff | `viddy -d <cmd>` |
| [mkcert](https://github.com/FiloSottile/mkcert) | Local HTTPS certs | `mkcert localhost` |
| [mise](https://mise.jdx.dev) | Runtime version manager | `mise use node@lts` |
| [btop](https://github.com/aristocratos/btop) | Resource monitor | `btop` |
| [bandwhich](https://github.com/imsnif/bandwhich) | Network traffic by process | `sudo bandwhich` |

### Security

| Tool | Purpose | Key usage |
| :--- | :--- | :--- |
| [trufflehog](https://github.com/trufflesecurity/trufflehog) | Scan secrets in git history | `trufflehog git file://.` |
| [trivy](https://trivy.dev) | Vulnerability scanner | `trivy fs .` |
| [nmap](https://nmap.org) | Network scanner | `nmap -sV <host>` |

---

## 📦 macOS Apps (Homebrew Cask)

| App | Purpose |
| :--- | :--- |
| [Ghostty](https://ghostty.org) | Terminal emulator |
| [Raycast](https://raycast.com) | Spotlight replacement |
| [Obsidian](https://obsidian.md) | Knowledge base / notes |
| [VSCode](https://code.visualstudio.com) | Code editor |
| [DBeaver](https://dbeaver.io) | Universal DB GUI |
| [LM Studio](https://lmstudio.ai) | Run LLMs locally |
| [Rectangle](https://rectangleapp.com) | Window management |
| [LocalSend](https://localsend.org) | Local file sharing (AirDrop alternative) |
| [Homerow](https://www.homerow.app) | Keyboard-driven UI navigation |

---

## 🔤 Fonts

- **FiraCode** — ligatures for code
- **JetBrains Mono** — clean and readable
- **Monaspace** — variable monospace superfamily
- **Recursive Code** — playful, highly legible
- **Symbols Nerd Font** — icons everywhere
