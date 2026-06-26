# ============================================================
# Docker image for Andes Compilation environment
# VERSION 1.0.5
# Author: castleodinland
# ============================================================
#
# 推送到阿里云镜像仓库:
#   docker tag andes_build_tools_v323:latest \
#     registry.cn-hangzhou.aliyuncs.com/castlecai/castle_test_image_vscode:latest
#   docker push registry.cn-hangzhou.aliyuncs.com/castlecai/castle_test_image_vscode:latest

FROM ubuntu:22.04

LABEL maintainer="castleodinland@gmail.com"

# ----------------------------------------------------------
# 工作目录
# ----------------------------------------------------------
WORKDIR /andes_tools

# ----------------------------------------------------------
# 环境变量
# ----------------------------------------------------------
ENV ANDES_COMPILE_PACKAGE=Andes_Tools_Chains \
    ANDES_COMPILE_UTILS=/andes_tools/AndesBuildTools/utils \
    PATH="/andes_tools/AndesBuildTools/nds32le-elf-mculib-v3s/bin:/andes_tools/AndesBuildTools/nds32le-elf-mculib-v3s/nds32le-elf/bin:/andes_tools/AndesBuildTools/utils:${PATH}"

# ----------------------------------------------------------
# 安装系统依赖与工具链
# ----------------------------------------------------------

# 复制工具链 tar.xz 并自动解压
ADD AndesToolsChain.tar.xz /andes_tools/

# 创建 /Andes/toolchains 符号链接，对齐 CMakeLists.txt 中硬编码的编译器路径
RUN mkdir -p /Andes && ln -s /andes_tools/AndesBuildTools /Andes/toolchains

# 安装 32-bit 支持、构建工具、CMake 及 Python 依赖（合并为一层）
# apt-get 添加 --fix-missing 和 Acquire::Retries 以应对镜像源偶发 502
RUN dpkg --add-architecture i386 && \
    apt-get update -o Acquire::Retries=3 && \
    apt-get install -y --no-install-recommends -o Acquire::Retries=3 \
        build-essential \
        cmake \
        make \
        git \
        zlib1g:i386 \
        python3 \
        python3-pip \
        zip \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir chardet

# ----------------------------------------------------------
# 项目文件
# ----------------------------------------------------------
# ADD auto_compile_proj.tar.xz /andes_tools/project/
ADD roboeffect_demo.tar.xz /andes_tools/project/

# ----------------------------------------------------------
# 默认入口
# ----------------------------------------------------------
CMD ["/bin/bash"]