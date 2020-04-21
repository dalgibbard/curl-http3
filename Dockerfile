FROM ubuntu:18.04
### Build instructions from: https://github.com/curl/curl/blob/master/docs/HTTP3.md
# upgrade OS
RUN echo "\n\n\033[0;32m===> UPDATING OS\033[0m" && sleep 2 && \
      apt-get update && \
      apt-get dist-upgrade -y && \
# build tools
      echo "\n\n\033[0;32m===> INSTALLING BUILD DEPENDANCIES\033[0m" && sleep 2 && \
      apt-get install -y build-essential git autoconf libtool pkg-config && \
# remove existing curl if present
      echo "\n\n\033[0;32m===> REMOVING EXISTING CURL INSTALL\033[0m" && sleep 2 && \
      apt-get purge -y curl && \
# build openssl
      echo "\n\n\033[0;32m===> BUILD OPENSSL\033[0m" && sleep 2 && \
      git clone --depth 1 -b OpenSSL_1_1_1d-quic-draft-27 https://github.com/tatsuhiro-t/openssl && \
      cd openssl && \
      ./config enable-tls1_3 --prefix=/usr/local && \
      make -j `lscpu | awk /"^Core"/'{print$NF}'` && \
      make install_sw && \
      cd ../ && \
# build nghttp3
      echo "\n\n\033[0;32m===> BUILD NGHTTP3\033[0m" && sleep 2 && \
      git clone https://github.com/ngtcp2/nghttp3 && \
      cd nghttp3 && \
      autoreconf -i && \
      ./configure --prefix=/usr/local --enable-lib-only && \
      make -j `lscpu | awk /"^Core"/'{print$NF}'` && \
      make install && \
      cd ../ && \
# build ngtcp2
      echo \n\n"\033[0;32m===> BUILD NGTCP2\033[0m" && sleep 2 && \
      git clone https://github.com/ngtcp2/ngtcp2 && \
      cd ngtcp2 && \
      autoreconf -i && \
      ./configure PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib/pkgconfig LDFLAGS="-Wl,-rpath,/usr/local/lib" --prefix=/usr/local && \
      make -j `lscpu | awk /"^Core"/'{print$NF}'` && \
      make install && \
      cd ../ && \
# build curl
      echo "\n\n\033[0;32m===> BUILD CURL\033[0m" && sleep 2 && \
      git clone https://github.com/curl/curl && \
      cd curl && \
      ./buildconf && \
      LDFLAGS="-Wl,-rpath,/usr/local/lib" ./configure --with-ssl=/usr/local --with-nghttp3=/usr/local --with-ngtcp2=/usr/local --enable-alt-svc && \
      make -j `lscpu | awk /"^Core"/'{print$NF}'` && \
      make install && \
      cd ../ && \
# cleanup
      echo "\n\n\033[0;32m===> CLEANUP\033[0m" && sleep 2 && \
      apt-get purge build-essential git autoconf libtool pkg-config -y && \
      apt-get clean all && \
      rm -rf openssl nghttp3 ngtcp2 curl && \
# check
      echo "\n\n\033[0;32m===> CHECK\033[0m" && sleep 2 && \
      curl --version

# Last bits
ENTRYPOINT ["curl"]
