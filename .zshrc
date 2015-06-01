HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt append_history           # append
setopt hist_ignore_all_dups     # no duplicate
unsetopt hist_ignore_space      # ignore space prefixed commands
setopt hist_reduce_blanks       # trim blanks
setopt inc_append_history       # add commands as they are typed, don't wait until shell exit
setopt share_history            # share hist between sessions
setopt ignoreeof                # don't exit the shell on ^D (EOF)

# emacs bindings
bindkey -e
# make delete key work
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char

# autocomplete
autoload -Uz compinit
compinit

# OS-specific things
if [[ "$OSTYPE" =~ ^darwin.*$ ]]; then
    # set pkgsrc paths
    # see: http://pkgsrc.joyent.com/install-on-osx/
    PATH=/usr/pkg/sbin:/usr/pkg/bin:$PATH
    MANPATH=/usr/pkg/man:$MANPATH

    # use pkgsrc's GNU coreutils (prefixed with 'g')
    # requires at least: coreutils findutils gsed
    alias du='gdu'
    alias ls='gls -F --color=auto'
    alias df='gdf'
    alias rm='grm'
    alias cp='gcp'
    alias mv='gmv'
    alias mkdir='gmkdir'
    alias rmdir='grmdir'
    alias chmod='gchmod'
    alias chown='gchown'
    alias ln='gln'
    alias find='gfind'
    alias sed='gsed'
    alias dircolors='gdircolors'

elif [[ "$OSTYPE" =~ ^linux.*$ ]]; then
    # aliases
    alias ls='ls -F --color=auto'
fi

alias less='less -R' # preserves colors in GNU coreutils' `less`

# solarized dircolors
[[ -r ~/.dircolors.ansi-dark ]] && eval `dircolors ~/.dircolors.ansi-dark`

# Environment
export PS1='[%n@%m: %~]$ '
export EDITOR=vim
export PAGER=less

# look for Ansible hosts file in current directory
export ANSIBLE_HOSTS=hosts

# Enable user's "global" npm packages
if [[ -d ~/.npm-packages ]]; then
    PATH=$PATH:~/.npm-packages/bin
fi

# Enable pyenv
# See: https://github.com/yyuu/pyenv#basic-github-checkout
if [[ -d ~/.pyenv ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    PATH="$PYENV_ROOT/bin:$PATH"

    eval "$(pyenv init -)"
    # optionally enable pyenv-virtualenv
    # See: https://github.com/yyuu/pyenv-virtualenv
    if [[ -d ~/.pyenv/plugins/pyenv-virtualenv ]]; then
        eval "$(pyenv virtualenv-init -)"
    fi
fi

# If a private bin directory exists, add it to PATH
[[ -d ~/bin ]] && PATH=$PATH:~/bin

# If a binary go distribution exists, add it to PATH
# From here: http://golang.org/dl/
if [[ -d ~/Downloads/go ]]; then
    export GOROOT=~/Downloads/go
    export GOPATH=~/src/go
    PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

export PATH
export MANPATH
