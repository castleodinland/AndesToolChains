# Docker image of Andes Compilation environment
# VERSION 1.0.4
# Author: castleodinland

#base image ubuntu22.04
FROM ubuntu:22.04

#MAINTAINER not used anymore?
LABEL maintainer="castleodinland@gmail.com"

#define work folder
ENV WORK_PATH /usr/local/

#RUN mkdir -p /Andes

#define Andes ToolChain folder name
ENV ANDES_COMPILE_PACKAGE Andes_Tools_Chains

#copy Andes ToolChains
ADD AndesToolsChain.tar.xz ./
#ADD nds32le-elf-mculib-v3s.txz ./Andes/toolschain

#install packages
RUN apt-get update 
RUN apt-get install make
RUN echo 'y' | apt-get install lib32z1 
RUN echo 'y' | apt install python3
#RUN apt-get install python3-pip
RUN echo 'y' | apt-get install zip

ENV PATH=/Andes/toolchains/nds32le-elf-mculib-v3s/bin:$PATH
ENV PATH=/Andes/toolchains/nds32le-elf-mculib-v3s/nds32le-elf/bin:$PATH

#SDK package to test compiler
#ADD auto_compile_proj.tar.xz ./


