FROM debian:stretch as builder

RUN apt-get update && apt-get install -y curl

ENV BABC_VERSION=0.19.4
ENV BABC_CHECKSUM="0455ae2a8106fc1f20f8229e10baac4c7a496bc680974fa8fad05268189682c6 bitcoin-abc-${BABC_VERSION}-x86_64-linux-gnu.tar.gz"

RUN curl -SLO "https://download.bitcoinabc.org/${BABC_VERSION}/linux/bitcoin-abc-${BABC_VERSION}-x86_64-linux-gnu.tar.gz" \
  && echo "${BABC_CHECKSUM}" | sha256sum -c - | grep OK \
  && tar -xzf bitcoin-abc-${BABC_VERSION}-x86_64-linux-gnu.tar.gz

FROM bitnami/minideb:stretch
ENV BABC_VERSION=0.19.4
RUN useradd -m bitcoin
RUN apt-get remove -y --allow-remove-essential --purge adduser gpgv mount hostname gzip login sed
USER bitcoin
COPY --from=builder /bitcoin-abc-${BABC_VERSION}/bin/bitcoind /bin/bitcoind
RUN mkdir -p /home/bitcoin/.bitcoin
ENTRYPOINT ["bitcoind"]
CMD ["-printtoconsole"]
