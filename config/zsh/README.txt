debian_dotfiles - ZSH Config
-------------------------------

> ZSH configuration files for Debian-based systems

config/zsh/
├── .p10k.zsh               Configuration for the PowerLevel10K ZSH prompt
├── .zlogin                 Startup tasks, executed when the shell is launched
├── .zlogout                Cleanup tasks, executed when the shell is exited
├── .zshenv                 Core environmental variables, used to configure file locations for dotfiles
├── .zshrc                  Entry point for ZSH config, here all the other files are imported
├── aliases/
│  ├── flutter.zsh          Aliases, shortcuts and helper functions for Flutter development
│  ├── functions.zsh        Utility shell functions (mkcd, extract, serve, etc.)
│  ├── general.zsh          General aliases and short functions for common CLI tasks
│  ├── git.zsh              Aliases, shortcuts and helper functions for working with Git
│  ├── node-js.zsh          Aliases, shortcuts and helper functions for JS/ Node.js development
│  └── rust.zsh             Aliases and helpers for Rust development
└── helpers/
   └── setup-zinit.zsh      Installs and configures zinit plugin manager, loads plugins

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ Source: https://github.com/grakaja77/debian_dotfiles                          ┃
┃ Originally forked from Lissy93/dotfiles (MIT licensed)                        ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
