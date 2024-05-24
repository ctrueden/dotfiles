FROM condaforge/miniforge3

RUN apt-get update && \
    apt-get install -y sudo vim zsh && \
    adduser --disabled-password --gecos "" me && \
    echo "me ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chsh -s /bin/zsh me

USER me
WORKDIR /home/me

RUN git clone https://github.com/ctrueden/dotfiles && \
    printf 'Curtis Rueden\nctrueden@wisc.edu\n' | dotfiles/setup.sh && \
    /bin/zsh -i -c echo 'Bootstrapping complete!' && \
    mamba init zsh

# Reap zombie processes properly; see:
# https://github.com/krallin/tini?tab=readme-ov-file#why-tini
ENTRYPOINT ["tini", "--"]

CMD [ "/bin/zsh" ]
