USERNAME=$(whoami)
HOSTNAME="GANDALF"
UID=$UID
GID=$(id -g)
HOME=$HOME

cat << 'EOF' > Dockerfile
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
EOF

cat << EOF > docker-compose.yml
version: '3'
services:
    my.ubuntu:
        working_dir: $HOME
        build:
            context: .
            dockerfile: Dockerfile
            args:
                USERNAME: $USERNAME
                USER_UID: $UID
                USER_GID: $GID
        volumes:
            # - /etc/group:/etc/group:ro
            # - /etc/passwd:/etc/passwd:ro
            # - /etc/shadow:/etc/shadow:ro
            - .:/workspace
        user: $UID:$GID
        hostname: $HOSTNAME

        tty: true
        # command: /bin/bash -c "while sleep 1000; do :; done"
EOF






# # Create the user
# RUN groupadd --gid $USER_GID $USERNAME \
#     && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME
# #     #
# #     # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
# RUN apt-get update \
#     && apt-get install -y sudo \
#     && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
#     && chmod 0440 /etc/sudoers.d/$USERNAME

# USER $USERNAME

# # RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# # USER mgkim

# # RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true && \
# #     git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
# #     git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \

