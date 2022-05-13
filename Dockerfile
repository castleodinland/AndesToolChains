# Docker image of hbase cluster
# VERSION 0.0.1
# Author: Castle

#基础镜像使用ubuntu22.04
FROM ubuntu:22.04

#作者
MAINTAINER CastleOdinland <castleodinland@gmail.com>

#定义工作目录
ENV WORK_PATH /usr/local/

#RUN mkdir -p /Andes

#定义Andes ToolChain文件夹名称
ENV ANDES_COMPILE_PACKAGE Andes_Tools_Chains

#把Andes ToolChain安装包从本地电脑复制到工作目录
ADD AndesToolsChain.tar.xz /
#ADD nds32le-elf-mculib-v3s.txz ./Andes/toolschain

#install packages
RUN apt-get update 
RUN apt-get install make
RUN echo 'y' | apt-get install lib32z1 
RUN echo 'y' | apt install python3
#RUN apt-get install python3-pip

ENV PATH=/Andes/toolchains/nds32le-elf-mculib-v3s/bin:$PATH
ENV PATH=/Andes/toolchains/nds32le-elf-mculib-v3s/nds32le-elf/bin:$PATH

#ADD auto_compile_proj.tar.xz ./


