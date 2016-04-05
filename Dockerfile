FROM meteorhacks/meteord:devbuild
RUN apt-get update
RUN apt-get install -y vim nano