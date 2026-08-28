# ✦ dotfiles

> _"A developer's environment is their most personal tool."_

My macOS dev machine configuration — batteries included, opinions strong.

```
 ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
 ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
 ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
 ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
 ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
 ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
```

---

## ⚡ Quick Install

Clone the repository, then run the bootstrap:

```bash
git clone https://github.com/davidnussio/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh all
```

The `all` command starts with a timestamped backup of existing managed files.

---

## 🗂 What's Inside

```
dotfiles/
├── Brewfile                    # All CLI tools & macOS apps via Homebrew
├── install.sh                  # Bootstrap script
├── git/
│   ├── .gitconfig              # Git config with delta, aliases, signing
│   └── .gitignore_global       # Global gitignore
├── config/
│   ├── fish/                   # Fish shell — config, functions, completions
│   ├── nvim/                   # Neovim config (lazy.nvim)
│   ├── zellij/                 # Multiplexer config + development layout
│   ├── starship.toml           # Starship prompt
│   ├── mise/                   # mise-en-place runtime manager
│   └── topgrade.toml           # Topgrade updater config
└── Application Support/
    └── com.mitchellh.ghostty/  # Ghostty terminal config
```

---

## 🛠 Stack

| Layer | Tool |
|---|---|
| Shell | [Fish](https://fishshell.com) + [Starship](https://starship.rs) |
| Terminal | [Ghostty](https://ghostty.org) |
| Editor | [Neovim](https://neovim.io) (lazy.nvim) + VSCode |
| Multiplexer | [Zellij](https://zellij.dev) |
| Package manager | [Homebrew](https://brew.sh) |
| Runtime manager | [mise](https://mise.jdx.dev) |
| File navigation | [yazi](https://github.com/sxyazi/yazi) + [zoxide](https://github.com/ajeetdsouza/zoxide) + [fzf](https://github.com/junegunn/fzf) |
| Git TUI | [lazygit](https://github.com/jesseduffield/lazygit) + [delta](https://github.com/dandavison/delta) |
| `ls` | [eza](https://github.com/eza-community/eza) |
| `cat` | [bat](https://github.com/sharkdp/bat) |
| `find` | [fd](https://github.com/sharkdp/fd) |
| `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) |
| HTTP | [xh](https://github.com/ducaale/xh) + [hurl](https://hurl.dev) |
| Load testing | [oha](https://github.com/hatoo/oha) |
| Kubernetes | [k9s](https://k9scli.io) + [kubectx](https://github.com/ahmetb/kubectx) + [stern](https://github.com/stern/stern) |
| Security | [trufflehog](https://github.com/trufflesecurity/trufflehog) + [trivy](https://trivy.dev) |
| Shell history | [Atuin](https://atuin.sh) |
| Secrets | [SOPS](https://getsops.io) + [age](https://age-encryption.org) |

---

## 📖 Cheatsheet

See [`cheatsheet.md`](./cheatsheet.md) for all keybindings, aliases, and abbreviations.

---

## 📄 License

MIT
