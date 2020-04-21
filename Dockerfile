FROM ubuntu:18.04
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y build-essential git autoconf libtool pkg-config && apt-get remove -y curl

### Build instructions from: https://github.com/curl/curl/blob/master/docs/HTTP3.md

# OpenSSL
RUN git clone --depth 1 -b OpenSSL_1_1_1d-quic-draft-27 https://github.com/tatsuhiro-t/openssl
WORKDIR openssl
RUN ./config enable-tls1_3 --prefix=/usr/local
RUN make -j `lscpu | awk /"^Core"/'{print$NF}'`
RUN make install_sw

# nghttp3
WORKDIR /
RUN git clone https://github.com/ngtcp2/nghttp3
WORKDIR nghttp3
RUN autoreconf -i
RUN ./configure --prefix=/usr/local --enable-lib-only
RUN make -j `lscpu | awk /"^Core"/'{print$NF}'`
RUN make install

# ngtcp2
WORKDIR /
RUN git clone https://github.com/ngtcp2/ngtcp2
WORKDIR ngtcp2
RUN autoreconf -i
RUN ./configure PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib/pkgconfig LDFLAGS="-Wl,-rpath,/usr/local/lib" --prefix=/usr/local
RUN make -j `lscpu | awk /"^Core"/'{print$NF}'`
RUN make install

# curl
WORKDIR /
RUN git clone https://github.com/curl/curl
WORKDIR curl
RUN ./buildconf
RUN LDFLAGS="-Wl,-rpath,/usr/local/lib" ./configure --with-ssl=/usr/local --with-nghttp3=/usr/local --with-ngtcp2=/usr/local --enable-alt-svc
RUN make -j `lscpu | awk /"^Core"/'{print$NF}'`
RUN make install

# Last bits
ENTRYPOINT ["curl"]
