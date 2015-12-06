FROM ubuntu

ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8

WORKDIR /fp

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 575159689BEFB442
RUN echo 'deb http://download.fpcomplete.com/ubuntu/wily stable main'|sudo tee /etc/apt/sources.list.d/fpco.list
RUN apt-get -y update
RUN apt-get -y install stack git
RUN git clone https://github.com/mdulac/fp-in-haskell-monad.git

CMD /bin/bash
