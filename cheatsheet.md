# Command-Line Cheatsheet

## Hotkeys

| Keybinding      | Description                                       |
| :-------------- | :------------------------------------------------ |
| `Ctrl+T`        | Fuzzy find files                                  |
| `Ctrl+R`        | Reverse command search                            |
| `Alt+C`         | Change directory (fuzzy find)                     |
| `Alt+Shift+C`   | Change directory (fuzzy find, including hidden)   |
| `Alt+G`         | Open file with default application                |
| `Alt+O`         | Open file with editor                             |
| `Alt+Up`        | Previous directory                                |
| `Alt+Left`      | Previous directory                                |
| `Alt+Right`     | Next directory                                    |

## Aliases & Abbreviations

| Alias/Abbr         | Command                                     | Description                        |
| :----------------- | :------------------------------------------ | :--------------------------------- |
| `fsource`          | `source ~/.config/fish/config.fish`         | Reload fish config                 |
| `o`                | `open`                                      | Open file/directory                |
| `tw`               | `timew`                                     | Timewarrior                        |
| `vi`, `vim`, `n`   | `nvim`                                      | Neovim                             |
| `efish`            | `nvim ~/.config/fish/config.fish`           | Edit fish config                   |
| `icat`             | `kitty +kitten icat`                        | Display image in kitty             |
| `reload`           | `exec $SHELL -l`                            | Reload shell                       |
| `playground`       | `cd ~/Developer/playground && code .`       | Open playground in VSCode          |
| `agi`              | `ag --ignore ...`                           | Silver searcher with ignores       |
| `lst`              | `tree -a -I ...`                            | Tree view with ignores             |
| `git-clean-branches` | `git fetch --prune && git gc`               | Prune and garbage collect git      |
| `ls`               | `eza`                                       | List files                         |
| `lsa`              | `eza -a`                                    | List all files                     |
| `ll`               | `eza -lh --group-directories-first --icons` | List files (long format)           |
| `lla`              | `ll -a`                                     | List all files (long format)       |
| `lt`               | `eza --tree --level=2 --long --icons --git` | Tree view (2 levels)               |
| `lta`              | `lt -a`                                     | Tree view (all, 2 levels)          |
| `ff`               | `fzf --preview 'batcat ...'`                | Fuzzy find with preview            |
| `fd`               | `fdfind`                                    | Find files                         |
| `cat`              | `bat --plain`                               | Cat with bat                       |
| `catl`             | `bat`                                       | Cat with bat (with line numbers)   |

## Git Abbreviations

| Abbreviation | Command               |
| :----------- | :-------------------- |
| `gcm`        | `git checkout master` |
| `gcb`        | `git checkout -b`     |
| `gco`        | `git checkout`        |
| `gbb`        | `git checkout -`      |
| `g`          | `git`                 |
| `ga`         | `git add`             |
| `gc`         | `git commit`          |
| `gs`         | `git status`          |
| `gd`         | `git diff`            |
| `gl`         | `git lg`              |
| `gpu`        | `git push`            |
| `gpl`        | `git pull`            |

## Installed Command-Line Tools (from Brewfile)

*   `htop`: Process viewer
*   `git`: Version control
*   `gh`: GitHub CLI
*   `fish`: Friendly interactive shell
*   `fisher`: Fish shell plugin manager
*   `starship`: Shell prompt
*   `mise`: Shell environment manager
*   `neovim`: Text editor
*   `httpie`: HTTP client
*   `stow`: Dotfile manager
*   `zoxide`: Directory jumper
*   `bat`: Cat clone with syntax highlighting
*   `eza`: Modern ls
*   `fd`: Find alternative
*   `ripgrep`: Grep alternative
*   `jq`: JSON processor
*   `fzf`: Fuzzy finder
*   `tmux`: Terminal multiplexer
*   `golang`: Go programming language
*   `colima`: Container runtime
*   `docker`: Container runtime
*   `podman`: Container runtime
*   `kubectl`: Kubernetes CLI
*   `croc`: Secure file transfer
*   `vercel-cli`: Vercel CLI
*   `firebase-cli`: Firebase CLI
*   `yt-dlp`: YouTube downloader
*   `ffmpeg`: Multimedia framework
*   `luarocks`: Lua package manager
*   `openfortivpn`: Fortinet VPN client
*   `yazi`: Filesystem manager
*   `sevenzip`: 7zip
*   `poppler`: PDF tools
*   `imagemagick`: Image processing
*   `turso`: Turso database CLI
*   `selene`: Lua formatter
*   `graphviz`: Graph visualization
*   `nmap`: Network scanner
*   `supabase`: Supabase CLI
*   `gemini-cli`: Gemini CLI
