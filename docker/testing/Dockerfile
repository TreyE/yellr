FROM treyedocker/centos_7_elixir_1_9_1:latest

ENV ELIXIR_VERSION=1.9.1 \
      LANG=en_US.UTF-8 \
      LANGUAGE=en_US:en \
      LC_ALL=en_US.UTF-8

COPY . /home/elixir/yellr
COPY docker/testing/testing_status_report /home/elixir/yellr/
COPY docker/testing/test.exs /home/elixir/yellr/config/
WORKDIR /home/elixir/yellr
RUN mix deps.get && pushd assets && yarn install && popd && pushd test_reports && yarn install && popd
