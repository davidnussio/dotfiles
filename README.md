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

The whole machine is declared in [`mise.toml`](./mise.toml) and applied with
[`mise bootstrap`](https://mise.jdx.dev/bootstrap.html): Homebrew formulae and
casks, dotfile symlinks, macOS defaults, login shell, runtimes and a final setup
task. Homebrew itself is not required — mise installs bottles and casks into
`/opt/homebrew` on its own (an existing Homebrew keeps working alongside).

On a fresh Mac:

```bash
curl https://mise.run | sh
~/.local/bin/mise bootstrap --from https://github.com/davidnussio/dotfiles.git --from-dir ~/.dotfiles --prompt-vars
```

`--prompt-vars` asks once for the git identity written to `~/.gitconfig.local`.

From an existing checkout:

```bash
cd ~/.dotfiles
mise trust
mise bootstrap --dry-run      # preview every change
mise bootstrap                # apply
mise bootstrap status         # compare this machine with the config
```

Existing real files where a symlink should go stop the run; check them with
`mise dot diff`, then rerun with `--force-dotfiles` to replace them.

### Day-to-day

From the checkout (`use` writes to `./mise.toml`):

```bash
mise bootstrap packages use brew:<formula>       # install and record a formula
mise bootstrap packages use brew-cask:<cask>     # install and record an app
mise bootstrap packages upgrade                  # upgrade declared packages (also run by topgrade)
mise bootstrap packages prune --dry-run          # formulae no config declares
```

---

## 🗂 What's Inside

```
dotfiles/
├── mise.toml                   # mise bootstrap: packages, dotfiles, macOS defaults, shell
├── macos/                      # Files copied into ~/Library
├── bin/dothelp                 # Yazi-style browser for these docs (`dothelp`, Alt+/)
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
| Machine setup | [mise bootstrap](https://mise.jdx.dev/bootstrap.html) |
| Package manager | [Homebrew](https://brew.sh) formulae & casks, via mise |
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

Or browse everything from the terminal with `dothelp` (or `Alt+/` at the fish
prompt): a yazi-style three-column view of the cheatsheet, fish abbreviations,
aliases and functions, packages, dotfile links and this README, read live from
the repository. `j/k` move, `h/l` leave/enter, `/` filter, `s` search
everywhere, `y` copy, `e` open the source in `$EDITOR`, `Enter` pick the command
(copied, or inserted at the prompt with `Alt+/`), `?` help.

---

## 📄 License

MIT
