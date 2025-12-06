# 脚本位置
my_funcs=~/.zsh_functions
fpath=($my_funcs $fpath)
if [[ -d $my_funcs ]]; then
    for func in $my_funcs/*(N.:t); do
        autoload -Uz "$func"
    done
fi
autoload -Uz compinit && compinit


# zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Powerlevel10k 主题
#zinit ice depth=1
#zinit light romkatv/powerlevel10k

# 语法高亮
zinit load zdharma-continuum/history-search-multi-word
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
# 自动补全
zinit ice wait lucid blockf
zinit light zsh-users/zsh-completions
# fzf-tab
zinit light Aloxaf/fzf-tab
zstyle ':fzf-tab:*' fzf-flags \
    "--color=fg:#c0caf5,bg:-1,hl:#bb9af7" \
    "--color=fg+:#c0caf5,bg+:#33467c,hl+:#7dcfff" \
    "--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff" \
    "--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat -n --color=always ${(Q)realpath}'
zstyle ':completion:*:git-checkout:*' sort false

zinit ice wait lucid 
zinit light zdharma-continuum/fast-syntax-highlighting


HISTSIZE=10000 #历史记录的最大值
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE   #最大存储条数
HISTDUP=erase        #删除重复的记录
setopt appendhistory #追加历史记录
setopt sharehistory  #共享历史记录
setopt hist_ignore_space
setopt hist_ignore_all_dups #忽略重复的记录
setopt hist_save_no_dups    #不存储重复的记录
setopt hist_ignore_dups     #忽略重复的记录
setopt hist_find_no_dups    #不查找重复的记录
# 快捷命令的定义
alias c='clear' # 清屏
alias q='exit'  #退出终端

# zoxide
eval "$(zoxide init zsh --cmd cd)"

# ssh
alias sshcheck="ssh -T git@github.com"

export UV_INDEX_URL="https://mirrors.sustech.edu.cn/pypi/simple"
export PIP_INDEX_URL="https://mirrors.sustech.edu.cn/pypi/simple"

# fzf
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git" #显示隐藏文件,同时排除gitignore所忽略的文件
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"  # ctrl+t 启动fzf
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
# 预览窗口设置
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'" #ctrl+t预览文件内容
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'" #alt+t预览文件内容_fzf

_fzf_comprun(){
  local command=$1
  shift
  case "$command" in
  cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;; 
  export|unset) fzf --preview "eval 'echo \$' {}"                       "$@" ;; 
  ssh)          fzf --preview 'dig {}'                                  "$@" ;;
  *)            fzf --preview 'bat -n --color=always --line-range :500 {}' "$@" ;;
  esac
}

# the fuck
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# bat 
alias cat="bat"
export BAT_THEME="tokyonight_night" # 设置主题
# eza 
alias ls="eza -a --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --git-ignore --git-repos-no-status"

# 快捷命令的定义
alias c='clear' # 清屏
alias q='exit'  #退出终端
alias lg='lazygit' 
alias Shizuku="adb shell sh /sdcard/Android/data/moe.shizuku.privileged.api/start.sh"
alias Scene="adb shell sh /storage/emulated/0/Android/data/com.omarea.vtools/up.sh"
alias tailwind="npx @tailwindcss/cli -i ./src/input.css -o ./src/output.css --watch"

os_name=$(uname -s | tr '[:upper:]' '[:lower:]')


# 根据操作系统加载对应的配置文件
os_config_file="$HOME/.zshrc_${os_name}"

if [[ -f "$os_config_file" ]]; then
    source "$os_config_file"
fi

eval "$(starship init zsh)"