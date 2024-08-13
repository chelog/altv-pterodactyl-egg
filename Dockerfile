FROM node:20-slim AS base

USER root

RUN apt-get update -y
RUN apt-get install -y curl libatomic1 libc-bin wget apt-transport-https ca-certificates gnupg
RUN apt autoremove -y
RUN apt-get clean
RUN npm i -g altv-pkg@latest

RUN useradd -m -d /home/container container

FROM base AS runtime
LABEL author='Dmitry Antonov' maintainer='chelog@octothorp.team'

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

RUN echo '{"loadBytecodeModule":true}' > .altvpkgrc.json

COPY ./entrypoint.sh /entrypoint.sh
CMD [ "/bin/bash", "/entrypoint.sh" ]
