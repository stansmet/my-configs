# ~/.bashrc — ревизия 2025-05-18

###############################################################################
# 0. Выходим, если не интерактивный шелл
[[ $- != *i* ]] && return

###############################################################################
# 1. Безопасность и строгие дефолты
set -o noclobber          # >> не перезаписывает файлы
umask 077                 # файлы доступны только владельцу

if command -v trash-put &>/dev/null; then
  alias rm='trash-put'
else
  alias rm='rm -i'
fi
alias cp='cp -i'
alias mv='mv -i'

###############################################################################
# 2. История (большая, сортированная, с таймстемпами)
HISTSIZE=200000
HISTFILESIZE=400000
HISTCONTROL=ignoredups:erasedups
HISTTIMEFORMAT='%F %T '
shopt -s histappend              # не перетирать history

###############################################################################
# 3. Bash-улучшалки
shopt -s autocd globstar checkwinsize cdspell

###############################################################################
# 4. Вспомогательные функции
__git_branch() {
  command -v git &>/dev/null &&
  git rev-parse --is-inside-work-tree &>/dev/null &&
  git symbolic-ref --quiet --short HEAD 2>/dev/null
}

# Хук: вызывается Bash-ем перед каждым prompt
__update_prompt() {
  local exit_code=$?        # код предыдущей команды (сохранили СРАЗУ!)
  history -a; history -c; history -r   # синхронизируем историю

  # Ветка Git (или "")
  local branch=""
  branch="$(__git_branch)"

  # Цвета
  local cyan='\[\e[0;36m\]'
  local yellow='\[\e[0;33m\]'
  local green='\[\e[0;32m\]'
  local red='\[\e[0;31m\]'
  local reset='\[\e[0m\]'

  # Базовый prompt: user@host:~/dir
  PS1="${cyan}\u@\h${reset}:${yellow}\w${reset}"

  # Добавим [ветку], если мы в репо
  [[ -n $branch ]] && PS1+="${yellow}[${branch}]${reset}"

  # Виртуальное окружение Python
  if [[ -n $VIRTUAL_ENV ]]; then
    PS1="(${cyan}$(basename "$VIRTUAL_ENV")${reset}) ${PS1}"
  fi

  # Хвост: зелёный $, либо красный ✗(код)
  if [[ $exit_code -eq 0 ]]; then
    PS1+="${green}$ ${reset}"
  else
    PS1+="${red}✗(${exit_code}) ${reset}"
  fi
}

PROMPT_COMMAND="__update_prompt"

###############################################################################
# 5. PATH: добавляем каталоги, если они есть
for d in "$HOME/.local/bin" "$HOME/bin" "$HOME/go/bin" "$HOME/.cargo/bin"; do
  [[ -d $d && ":$PATH:" != *":$d:"* ]] && PATH="$d:$PATH"
done
export PATH

###############################################################################
# 6. Aliases
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

# Docker / Compose / Kubernetes
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dcu='docker compose up -d'
alias dcl='docker compose logs -f --tail=50'
alias k='kubectl'
alias kg='kubectl get'
alias kx='kubectl config use-context'

# Git helpers
alias gs='git status -sb'
alias gc='git commit'
alias gp='git push'
alias gl='git pull --ff-only'

###############################################################################
# 7. Дополнительные функции
extract () {   # универсальный распаковщик
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)  tar xjf "$1"   ;;
      *.tar.gz)   tar xzf "$1"   ;;   # ← исправлено
      *.bz2)      bunzip2 "$1"   ;;
      *.rar)      unrar x "$1"   ;;
      *.gz)       gunzip "$1"    ;;
      *.tar)      tar xf "$1"    ;;
      *.tbz2)     tar xjf "$1"   ;;
      *.tgz)      tar xzf "$1"   ;;
      *.zip)      unzip "$1"     ;;
      *.Z)        uncompress "$1";;
      *) echo "'$1' — неизвестный формат" ; return 1 ;;
    esac
  else
    echo "'$1' не найден"
    return 1
  fi
}

