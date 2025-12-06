function uvnew --description 'Create and init uv project with pyproject.toml and default packages'
    set -l default_py "3.14"
    set -l base_packages ipykernel nbconvert numpy matplotlib 
    set -l py_ver $default_py
    set -l extra_pkgs
    # 检查是否有参数输入
    if count $argv > /dev/null
        set py_ver $argv[1]
        
        if test (count $argv) -gt 1
            set extra_pkgs $argv[2..-1]
        end
    end

    if test -f pyproject.toml
        echo "检测到已有 pyproject.toml，跳过 uv init。"
    else
        echo "正在初始化项目并生成 pyproject.toml (Python $py_ver)..."
        uv init --python $py_ver
        if test $status -ne 0
            echo "错误：uv init 失败"
            return 1
        end
    end

    # 如果 uv 创建了托管虚拟环境，则激活它
    if test -f .venv/bin/activate.fish
        source .venv/bin/activate.fish
        echo " 已自动激活虚拟环境"
    else
        echo "未发现 .venv/activate.fish，继续安装但不激活。"
    end

    echo "正在添加基础依赖到 pyproject.toml: $base_packages"
    if test -n "$extra_pkgs"
        echo "以及额外依赖: $extra_pkgs"
    end

    # 使用 uv add 写入并安装依赖
    uv add $base_packages $extra_pkgs
    if test $status -ne 0
        echo "错误：依赖安装失败"
        return 1
    end

    echo "项目初始化完成！"
    which python
end