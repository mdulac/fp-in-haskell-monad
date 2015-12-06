FROM ubuntu

VOLUME /fp

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 575159689BEFB442
RUN echo 'deb http://download.fpcomplete.com/ubuntu/wily stable main'|sudo tee /etc/apt/sources.list.d/fpco.list
RUN apt-get -y update
RUN apt-get -y install stack

WORKDIR /fp

CMD /bin/bash