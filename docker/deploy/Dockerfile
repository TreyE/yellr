FROM treyedocker/centos_7_base:latest

RUN mkdir /home/elixir
COPY yellr_release.zip /home/elixir/
RUN cd /home/elixir && unzip yellr_release.zip
ENV ELIXIR_VERSION=1.9.1 \
      LANG=en_US.UTF-8 \
      LANGUAGE=en_US:en \
      LC_ALL=en_US.UTF-8
COPY docker/deploy/start_server /home/elixir/yellr/
RUN chmod u+x /home/elixir/yellr/start_server
WORKDIR /home/elixir/yellr