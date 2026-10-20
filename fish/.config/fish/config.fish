# Homebrew 环境
/opt/homebrew/bin/brew shellenv fish | source

# 环境和路径变量
set -gx EDITOR "code"
set -gx VISUAL "code"
set -gx SUDO_EDITOR "code"
set -gx FCEDIT "code"
set -gx TERMINAL "wezterm"

# Locale
set -gx LANG "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"

# 工具环境
set -gx BAT_THEME "tokyonight_night"
set -gx PIP_INDEX_URL "https://mirrors.sustech.edu.cn/pypi/simple"

# 以下配置只用于交互式 shell
if not status is-interactive
    return
end

starship init fish | source

set -l teal 94e2d5
set -l mauve cba6f7
set -l pink f5c2e7
set -l peach fab387
set -l blue 89b4fa
set -l gray 1f1d2e

set -g fish_pager_color_progress $gray
set -g fish_pager_color_prefix $mauve
set -g fish_pager_color_completion $peach
set -g fish_pager_color_description $gray

# 关闭默认欢迎语
set -g fish_greeting

# man 颜色
set -g man_blink -o $teal
set -g man_bold -o $pink
set -g man_standout -b $gray
set -g man_underline -u $blue

# alias
alias ls="eza -a --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --git-ignore --git-repos-no-status"
abbr -a -g ll 'ls'
abbr -a -g la 'ls'

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


# pip / python 相关
alias pip='pip3'
alias python='python3'

# tailwind 前端构建
alias tailwind="npx @tailwindcss/cli -i ./src/input.css -o ./src/output.css --watch"

# SSH
alias sshcheck="ssh -T git@github.com"
alias sshconnect="ssh 'qianfu@10.250.209.225'"

# 将 cat 映射为 bat
alias cat='bat'

# The Fuck（命令纠错）
TF_SHELL=fish thefuck --alias | source
alias fk='fuck'

# Zoxide（智能目录跳转）
zoxide init fish | source
alias cd='z'

