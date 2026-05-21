FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates git sudo tini zsh && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --comment "It's-a me" me && \
    echo "me ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chsh -s /bin/zsh me

USER me
WORKDIR /home/me

RUN git clone https://github.com/ctrueden/dotfiles && \
    dotfiles/bin/install-packages && \
    printf 'Curtis Rueden\nctrueden@wisc.edu\n' | dotfiles/setup.sh && \
    /bin/zsh -i -c echo 'Bootstrapping complete!'

# Reap zombie processes properly; see:
# https://github.com/krallin/tini?tab=readme-ov-file#why-tini
ENTRYPOINT ["tini", "--"]

CMD [ "/bin/zsh" ]
