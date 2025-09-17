# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Path adjustments
if [ -d "$HOME/.bin" ]; then
	PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

# Ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

# List
alias la='ls -a'
alias ll='ls -la'
alias l='ls'
alias l.="ls -A | egrep '^\.'"

# Shell options
shopt -s autocd         # change to named directory
shopt -s cdspell        # autocorrects cd misspellings
shopt -s cmdhist        # save multi-line commands in history as single line
shopt -s dotglob        # dot file names are included in path expansion.
shopt -s histappend     # do not overwrite history
shopt -s expand_aliases # expand aliases

# ex = EXtractor for all kinds of archives.
# usage: ex <file>
ex() {
	if [ -f $1 ]; then
		case $1 in
		*.tar.bz2) tar xjf $1 ;;
		*.tar.gz) tar xzf $1 ;;
		*.bz2) bunzip2 $1 ;;
		*.rar) unrar x $1 ;;
		*.gz) gunzip $1 ;;
		*.tar) tar xf $1 ;;
		*.tbz2) tar xjf $1 ;;
		*.tgz) tar xzf $1 ;;
		*.zip) unzip $1 ;;
		*.Z) uncompress $1 ;;
		*.7z) 7z x $1 ;;
		*deb) ar x $1 ;;
		*.tar.xz) tar xf $1 ;;
		*.tar.zst) unzstd $1 ;;
		*) echo "'$1' cannot be extracted via ex()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# sshkill - stops running ssh-agents
sshkill() {
  if [[ $OSTYPE != 'msys' ]]; then
    killall ssh-agent
  else
    pid=$(ps aux | awk '{print $1, $8}' | awk /ssh-agent/ | awk '{print $1}')
    if [[ $pid =~ ^[0-9]+$ ]]; then
      kill $pid
    fi
  fi
}

# sshlist - list running ssh-agents
sshlist() {
  if [[ $OSTYPE != 'msys' ]]; then
    ps aux | awk '{print $11, $2}' | awk '/^ssh-agent/'
  else
    ps aux | awk '{print $8, $2}' | awk '/ssh-agent/'
  fi
}

# sshkeys - add private key to ssh-agent
sshkeys() {
  local agentName agentCheck=1 cmpTo
  local AGENT_ENV_FILE="${HOME}/.ssh/agent_env"

  case "$OSTYPE" in
    msys*)   agentName="/usr/bin/ssh-agent"; cmpTo=0 ;;
    linux*)  agentName="ssh-agent";          cmpTo=1 ;;
    *)       echo "Unsupported OS: $OSTYPE"; return 1 ;;
  esac

  # Load existing agent vars if the file exists
  if [[ -f "$AGENT_ENV_FILE" ]]; then
    source "$AGENT_ENV_FILE" > /dev/null

    # Check if agent is alive and socket exists
    if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null || [[ ! -S "$SSH_AUTH_SOCK" ]]; then
      rm -f "$AGENT_ENV_FILE"
      unset SSH_AGENT_PID SSH_AUTH_SOCK
    fi
  fi

  # Start a new agent if necessary
  if [[ -z "$SSH_AGENT_PID" || -z "$SSH_AUTH_SOCK" ]]; then
    eval "$(ssh-agent -s)" > /dev/null
    echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > "$AGENT_ENV_FILE"
    echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> "$AGENT_ENV_FILE"

    # Add keys only when a new agent is started
    if [[ -d $SSHHOME ]]; then
      for key in "$SSHHOME"/*.pub; do
        [[ -f "$key" ]] || continue
        ssh-add -q "${key%.*}" 2>/dev/null
      done
    else
      echo "ERROR: SSHHOME is not defined or not a directory."
    fi
  fi
}

# Create a file called .bashrc-personal and put all your personal aliases
# in there. They will not be overwritten by skel.
[[ -f $HOME/.bashrc_personal ]] &&
  source $HOME/.bashrc_personal
