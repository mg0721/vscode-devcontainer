ARG VARIANT=focal
FROM ubuntu:20.04
# FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

ARG USERNAME
ARG USER_UID
ARG USER_GID

ENV SHELL /bin/bash

COPY asset/sources.list.20.04 /etc/apt/sources.list

RUN apt-get update && \
    apt-get -y install --no-install-recommends apt-utils 2>&1

RUN  apt-get update && \
    apt-get install -y zsh \
    fonts-powerline \
    wget \
    git \
    vim \
    # locales \
    sudo \
    # procps \\
    # apt-transport-https \\
    ca-certificates \
    # gnupg-agent \\
    # software-properties-common \\
    # lsb-release \\
    curl

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME
RUN apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# USER $USERNAME

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
