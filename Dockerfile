FROM ubuntu

RUN apt-get update && \
        apt-get -y install \
        apt-transport-https \
        bash-completion \
        ca-certificates \
        curl \
        git \
        gnupg-agent \
        python3 \
        python3-pip \
        software-properties-common && \
        pip3 install --upgrade pip ipython

COPY docker.gpg /tmp/
RUN apt-key add /tmp/docker.gpg && \
        rm /tmp/docker.gpg && \
        apt-key fingerprint 0EBFCD88

RUN add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" && \
        apt-get update

RUN apt-get -y install docker-ce-cli

RUN curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose && \
        chmod +x /usr/bin/docker-compose

RUN useradd --create-home --shell=/bin/bash bashit && \
        usermod -aG root bashit
USER bashit
WORKDIR /home/bashit

RUN git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it

RUN ~/.bash_it/install.sh --interactive
RUN bash -i -c "bash-it enable completion docker docker-compose git pip3 system"

COPY entrypoint.sh /bin/
ENTRYPOINT [ "/bin/entrypoint.sh" ]
CMD /bin/bash