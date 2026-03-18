FROM debian:bookworm-slim

LABEL maintainer "grakaja77"
LABEL org.opencontainers.image.source https://github.com/grakaja77/debian_dotfiles

# Parameters
ARG user=ryanreid
ARG uid=1000
ARG dotfiles_repo=https://github.com/grakaja77/debian_dotfiles.git

# Install system packages
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    ca-certificates \
    curl \
    wget \
    git \
    zsh \
    build-essential \
    coreutils \
    file \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/zsh -u ${uid} ${user} && \
    echo "${user} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV DOTFILES_DIR="/home/${user}/.dotfiles"

RUN git clone --recursive ${dotfiles_repo} ${DOTFILES_DIR} && \
    chown -R ${user}:${user} ${DOTFILES_DIR}

RUN chmod u+x "${DOTFILES_DIR}/install.sh"

USER ${user}
WORKDIR /home/${user}

RUN cd $DOTFILES_DIR && $DOTFILES_DIR/install.sh --auto-yes

ENV HISTFILE=/home/${user}/.cache/.zsh_history

ENTRYPOINT [ "/bin/zsh" ]
