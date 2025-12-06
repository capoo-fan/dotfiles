starship init fish | source

# Homebrew 环境
eval "$(/opt/homebrew/bin/brew shellenv)"

# 环境和路径变量
set -gx EDITOR "code"
set -gx VISUAL "code"
set -gx SUDO_EDITOR "code"
set -gx FCEDIT "code"
set -gx TERMINAL "wezterm"

set -l teal 94e2d5
set -l flamingo f2cdcd
set -l mauve cba6f7
set -l pink f5c2e7
set -l red f38ba8
set -l peach fab387
set -l green a6e3a1
set -l yellow f9e2af
set -l blue 89b4fa
set -l gray 1f1d2e
set -l black 191724

set -g fish_pager_color_progress $gray
set -g fish_pager_color_prefix $mauve
set -g fish_pager_color_completion $peach
set -g fish_pager_color_description $gray

# 关闭默认欢迎语
set -g fish_greeting

# Git prompt 配置（如果你还看 fish 自带的 git 提示）
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_cleanstate '✔'
set -g __fish_git_prompt_char_dirtystate '✚'
set -g __fish_git_prompt_char_invalidstate '✖'
set -g __fish_git_prompt_char_stagedstate '●'
set -g __fish_git_prompt_char_stashstate '⚑'
set -g __fish_git_prompt_char_untrackedfiles '?'
set -g __fish_git_prompt_char_upstream_ahead ''
set -g __fish_git_prompt_char_upstream_behind ''
set -g __fish_git_prompt_char_upstream_diverged 'ﱟ'
set -g __fish_git_prompt_char_upstream_equal ''
set -g __fish_git_prompt_char_upstream_prefix ''''

# man 颜色
set -g man_blink -o $teal
set -g man_bold -o $pink
set -g man_standout -b $gray
set -g man_underline -u $blue

# Locale（用 fish 风格设置）
set -gx LANG "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"




#  alias
alias ls="eza -a --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --git-ignore --git-repos-no-status"
abbr -a -g ll 'ls'
abbr -a -g la 'ls -a'

# 常用目录/操作
abbr -a -g h 'cd $HOME'
abbr -a -g cls 'clear'
alias c='clear'
alias q='exit'

# 网络 / 工具
abbr -a -g ytmp3 'youtube-dl --extract-audio --audio-format mp3'
abbr -a -g cn 'ping -c 5 8.8.8.8'
abbr -a -g ipe 'curl ifconfig.co'

# 其他小工具
abbr -a -g genpass 'openssl rand -base64 20'
abbr -a -g sha 'shasum -a 256'
abbr -a -g untar 'tar -zxvf'

# sudo 别名（按需保留）
abbr -a -g please 'sudo'
# abbr -a -g fucking 'sudo'  # 如不需要就注释掉

# pip / python 相关
alias pip='pip3'
alias python='python3'

# tailwind 前端构建
alias tailwind="npx @tailwindcss/cli -i ./src/input.css -o ./src/output.css --watch"

# SSH
alias sshcheck="ssh -T git@github.com"
alias sshconnect="ssh 'qianfu@10.250.209.225'"
# bat 主题
set -gx BAT_THEME "tokyonight_night"



# 函数 / Plugin / 其他

# 将 cat 映射为 bat
alias cat='bat'

# The Fuck（命令纠错）
thefuck --alias | source
thefuck --alias fk | source

# Zoxide（智能目录跳转）
zoxide init fish | source
alias cd='z'

# pip 源
set -gx PIP_INDEX_URL "https://mirrors.sustech.edu.cn/pypi/simple"


