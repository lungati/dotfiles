HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=2000
setopt append_history           # append
setopt hist_ignore_all_dups     # no duplicate
setopt hist_ignore_space        # ignore space prefixed commands
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
    # explicitly add Homebrew binary paths just in case Terminal doesn't inherit it from macOS, for example Alacritty.
    PATH=$PATH:/usr/local/bin:/usr/local/sbin

    # Add brew stuff to MANPATH
    MANPATH=/usr/local/share/man:/usr/local/opt/postgresql@9.5/share/man:$PATH

    # opt out of Homebrew analytics
    # see: https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_EMOJI=1
    export HOMEBREW_NO_AUTO_UPDATE=1

    # use some GNU stuff from homebrew: coreutils findutils gnu-sed
    # requires at least: coreutils findutils gnu-sed
    PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

    alias grep='ggrep'

    # Add BasicTeX to PATH
    # See: https://tug.org/mactex/morepackages.html
    PATH=$PATH:/usr/local/texlive/2017basic/bin/x86_64-darwin

    # Manually manage Ruby shit for DSpace build environment (anything is better than RVM)
    # DSpace Mirage 2 build explicitly looks for GEM_HOME and GEM_PATH
    export GEM_HOME=~/.gem/ruby/2.5.1
    export GEM_PATH=~/.gem/ruby/2.5.1
    PATH=$PATH:~/.gem/ruby/2.5.1/bin

    # Use node@8 from Homebrew instead of NVM
    PATH=$PATH:/usr/local/opt/node@8/bin

    PATH=$PATH:/usr/local/opt/postgresql@9.5/bin
elif [[ "$OSTYPE" =~ ^linux.*$ ]]; then
    PATH=~/.local/bin:$PATH

    # Manually manage Ruby shit for DSpace build environment (anything is better than RVM)
    # DSpace Mirage 2 build explicitly looks for GEM_HOME and GEM_PATH
    export GEM_HOME=~/.gem/ruby/2.5.0
    export GEM_PATH=~/.gem/ruby/2.5.0
    PATH=$PATH:~/.gem/ruby/2.5.0/bin

    # System Node.js with local "global" package prefix, for DSpace build environment:
    #  $ npm config set prefix ~/.node_modules
    #  $ npm install -g bower grunt grunt-cli
    PATH=$PATH:~/.node_modules/bin
fi

alias ls='ls -F --color=auto'
alias less='less -R' # preserves colors in GNU coreutils' `less`

# solarized dircolors
[[ -r ~/.dircolors.ansi-dark ]] && eval `dircolors ~/.dircolors.ansi-dark`

# Environment
export PS1='[%n@%m: %~]$ '
export EDITOR=vim
export PAGER=less

# resize images using GraphicsMagick
#
#   $ smartresize DSC_0788.JPG 1920x1080 outputdir [quality]
#
# Similar to the one from SmashingMagazine, but ported to GraphicsMagick
# see: http://www.smashingmagazine.com/2015/06/efficient-image-resizing-with-imagemagick/
smartresize() {
    if [[ -z $4 ]]; then QUALITY=82; else QUALITY=$4; fi

    gm mogrify -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 2x0.5+0.7+0 -dither -quality $QUALITY -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace Line -strip -output-directory $3 $1
}

# optimize jpeg using GraphicsMagick
#
#   $ jpegoptimize DSC_0788.JPG outputdir [quality]
#
# Similar to smartresize above, but just optmizes the jpeg
jpegoptimize() {
    if [[ -z $3 ]]; then QUALITY=82; else QUALITY=$3; fi

    gm mogrify -filter Triangle -define filter:support=2 -unsharp 2x0.5+0.7+0 -dither -quality $QUALITY -define jpeg:fancy-upsampling=off -interlace Line -strip -output-directory $2 $1
}

# generate random password 15 characters long
# See: https://unix.stackexchange.com/questions/230673/how-to-generate-a-random-string
genpass() {
    </dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' | head -c 15 ; echo
}

# set GPG TTY
export GPG_TTY=$(tty)

# Refresh gpg-agent tty in case user switches into an X Session
gpg-connect-agent updatestartuptty /bye >/dev/null

# Speed up JVM start for short-lived Java programs
# See: https://zeroturnaround.com/rebellabs/your-maven-build-is-slow-speed-it-up/
export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
export PATH
export MANPATH
