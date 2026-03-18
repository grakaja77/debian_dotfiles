debian_dotfiles - Config
----------------------------

> Configuration files for apps, utils and services on Debian-based systems

The location on disk that files should be symlinked to is specified in symlinks.yaml
Run the install.sh script to apply settings based on system type and user preferences

Important: Take care to read through files thoroughly before applying any changes
And always make a backup of your pre-existing config files before over-writing them

---

config/
├── zsh/                      # ZSH (shell) settings, aliases, utils and plugin list
├── general/                  # All other config files
│  ├── .bashrc
│  ├── .gemrc
│  ├── .gitignore_global
│  ├── .gpg.conf
│  ├── .curlrc
│  ├── .gitconfig
│  ├── .wgetrc
│  └──  dnscrypt-proxy.toml
└── README.txt
