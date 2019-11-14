FROM debian:stretch as builder

RUN apt-get update && apt-get install -y curl

ENV BC_VERSION=0.18.1
ENV BC_CHECKSUM="600d1db5e751fa85903e935a01a74f5cc57e1e7473c15fd3e17ed21e202cfe5a bitcoin-${BC_VERSION}-x86_64-linux-gnu.tar.gz"

RUN curl -SLO "https://bitcoincore.org/bin/bitcoin-core-${BC_VERSION}/bitcoin-${BC_VERSION}-x86_64-linux-gnu.tar.gz" \
  && echo "${BC_CHECKSUM}" | sha256sum -c - | grep OK \
  && tar -xzf bitcoin-${BC_VERSION}-x86_64-linux-gnu.tar.gz

FROM bitnami/minideb:stretch
ENV BC_VERSION=0.18.1
RUN useradd -m bitcoin
RUN apt-get remove -y --allow-remove-essential --purge adduser gpgv mount hostname gzip login sed
USER bitcoin
COPY --from=builder /bitcoin-${BC_VERSION}/bin/bitcoind /bin/bitcoind
RUN mkdir -p /home/bitcoin/.bitcoin
ENTRYPOINT ["bitcoind"]
CMD ["-printtoconsole"]
