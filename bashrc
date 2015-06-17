export HISTCONTROL=ignoreboth
export HISTFILESIZE=2500
# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS
shopt -s checkwinsize

# Shortcuts for common operations
alias build_inplace='python setup.py build_ext --inplace'
alias build_clean='find . -name *.so -or -name *.pyc | xargs rm; rm -rf build'
alias pstats='python -m pstats'

# Change to Python's site-packages directory.
function cdsite {
  cd "$(python -c "import site; print site.getsitepackages()[-1]")"
}

# Change to the directory for a given python module
function cdpy {
  cd "$(python -c "import imp; print(imp.find_module('$1')[1])"
)"
}

function edit {
   subl $@ || gedit $@ &
}

# aliases
alias u='cd ..;'
alias ll='ls -l'
alias la='ls -a'

alias nano="nano -c"
alias open='xdg-open'
alias pi="ssh pi@10.0.1.112"
alias mpl="cd ~/workspace/matplotlib/lib/matplotlib/backends"
alias sk="cd ~/workspace/scikit-image/skimage"

alias gca='git commit -a --verbose'
alias gs='git status'
alias gsv='git status --verbose'
alias gpo='git push origin'
alias gp='git push origin'
alias gu='git pull upstream'
alias gb='git branch'
alias gd='git diff'
alias ga='git add'
alias gc='git commit --verbose'

eval "$(hub alias -s)"

source ~/.hub_bash_completion.sh

alias hc='hg commit --verbose'
alias hs='hg status'
alias hsv='hg status --verbose'
alias hpo='hg push origin'
alias hb='hg branches'
alias hco='hg checkout'
alias hd='hg diff'
alias hp='hg push'
alias ha='hg add'

source ~/hg_bash_completion

export SPYDER_DEBUG=True
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/anaconda/bin:$PATH"
#alias python=python3


function search() {
    grep -irn "$1" .
}

function gn() {
    git fetch upstream master
    git checkout -b "$1" upstream/master
}

function grb() {
    git fetch upstream master
    git rebase -i upstream/master
}

function gpr() {
    git checkout master
    git branch -D pr/$1 2>/dev/null
    git fetch upstream pull/$1/head:pr/$1
    git checkout pr/$1
}


# build up PS1 with source control annotation
function source_control {
  echo `python  -c """
import re
import subprocess as sp
output=''
try:
    git_text = sp.check_output(['git', 'status', '-b',
        '-s'], stderr=sp.STDOUT).decode('utf-8', 'replace')
except (sp.CalledProcessError, OSError):
    pass
else:
    match = re.match('## (.*)', git_text)
    if match:
        match = match.groups()[0]
        if '...' in match:
            match, _, _ = match.partition('...')
        output = '(%s) %s' % (match, len(git_text.splitlines()) - 1)
if not output:
    try:
        hg_text = sp.check_output(['hg', 'summary'], stderr=sp.STDOUT)
    except (sp.CalledProcessError, OSError):
        pass
    else:
        hg_text = hg_text.decode('utf-8', 'replace')
        match = re.search('branch: (.*)', hg_text)
        if 'commit: (clean)' in hg_text and match:
            print('%s 0' % match.groups()[0])
        elif match:
            lines = hg_text.splitlines()
            for line in lines:
                if line.startswith('commit:'):
                    numbers = re.findall('\d+', line)
                    dirty = sum(int(n) for n in numbers)
                    output = '%s %s' % (match.groups()[0], dirty)
print(output)"""`
}

RED='\[\033[1;31m\]'
GREEN='\[\033[01;32m\]'
YELLOW='\[\033[01;33m\]'
CYAN='\[\033[00;36m\]'
NO_COLOR='\[\033[0m\]'

export PS1=$GREEN'\u: '$CYAN'\w'$YELLOW' $(source_control)\n'$NO_COLOR'$ '
