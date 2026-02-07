# Docker image for Andes Compilation environment
# VERSION 1.0.4
# Author: castleodinland

#推送到阿里云镜像仓库：
#docker tag andes_build_tools_v323:latest registry.cn-hangzhou.aliyuncs.com/castlecai/castle_test_image_vscode:latest
#docker push registry.cn-hangzhou.aliyuncs.com/castlecai/castle_test_image_vscode:latest

FROM ubuntu:22.04

LABEL maintainer="castleodinland@gmail.com"

# 定义工作目录（推荐用 /workspace 或 /andes，避免污染 /usr/local/）
WORKDIR /andes_tools

# 定义工具链包名 ✅ 推荐格式
ENV ANDES_COMPILE_PACKAGE=Andes_Tools_Chains


# 复制工具链 tar.xz 并解压（假设 tar.xz 根目录就是 Andes/ 或直接 toolchains/，根据你的实际 tar 内容调整）
ADD AndesToolsChain.tar.xz /andes_tools/
# 如果 tar.xz 解压后是 Andes/ 目录，就用下面这行代替上面（更安全）
# RUN tar -xf AndesToolsChain.tar.xz && rm AndesToolsChain.tar.xz

# 启用 32-bit 支持 + 一次性更新源 + 安装所有 apt 包（合并层，效率高）
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        make \
        git \
        zlib1g:i386 \          
        python3 \
        python3-pip \
        zip \
        unzip \                
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir chardet

# 设置 PATH（根据你的 tar.xz 解压结构调整路径）
# 假设解压后在 /andes_tools/Andes/toolchains/nds32le-elf-mculib-v3s/bin
# 如果不是，请先 build 一次失败后 docker run -it 进去 ls /andes 查看实际路径
ENV PATH="/andes_tools/Andes/toolchains/nds32le-elf-mculib-v3s/bin:${PATH}"
ENV PATH="/andes_tools/Andes/toolchains/nds32le-elf-mculib-v3s/nds32le-elf/bin:${PATH}"
ENV PATH="/andes_tools/Andes/utils:${PATH}"

# 如果有 SDK 测试项目，可以在这里 ADD（注释掉了就先不加）
ADD auto_compile_proj.tar.xz /andes_tools/project/

# 可选：设置默认命令或 ENTRYPOINT，根据你的使用场景
# CMD ["/bin/bash"]