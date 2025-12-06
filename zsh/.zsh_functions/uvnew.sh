local default_py="3.12"
local base_packages=(ipykernel nbconvert numpy matplotlib)
local py_ver="${1:-$default_py}"
    

local extra_pkgs=()
if [[ $# -gt 0 ]]; then
    shift
    extra_pkgs=("$@") 
fi

if [[ -f "pyproject.toml" ]]; then
    print -P "检测到已有 pyproject.toml，跳过 uv init。%f"
else
    print -P "正在初始化项目并生成 pyproject.toml (Python $py_ver)...%f"
    uv init --python "$py_ver"
        
    if [[ $? -ne 0 ]]; then
        print -P "%F{red}❌ 错误：uv init 失败%f"
        return 1
    fi
fi

if [[ -f ".venv/bin/activate" ]]; then
    source .venv/bin/activate
    print -P "已自动激活虚拟环境%f"
else
    print -P "未发现 .venv/bin/activate，继续安装但不激活。%f"
fi


print -P "正在添加基础依赖: ${base_packages[*]}%f"
if [[ ${#extra_pkgs[@]} -gt 0 ]]; then
    print -P "额外依赖: ${extra_pkgs[*]}%f"
fi

uv add "${base_packages[@]}" "${extra_pkgs[@]}"
    
if [[ $? -ne 0 ]]; then
    print -P "错误：依赖安装失败%f"
    return 1
fi

print -P "项目初始化完成！%f"
which python