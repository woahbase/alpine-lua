# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
ARG LUAMAJMIN=5.1
#
ENV \
    LUAMAJMIN=${LUAMAJMIN}
#
RUN set -xe \
    && apk add --no-cache --purge -uU \
        lua${LUAMAJMIN} \
        lua${LUAMAJMIN}-dev \
        luarocks${LUAMAJMIN} \
        git \
    # no /usr/bin/lua since 5.2
    && case ${LUAMAJMIN} in \
        "5.2"|"5.3"|"5.4") \
               if [ ! -e "/usr/bin/lua"  ]; then ln -sf $(which  lua${LUAMAJMIN}) /usr/bin/lua;  fi \
            && if [ ! -e "/usr/bin/luac" ]; then ln -sf $(which luac${LUAMAJMIN}) /usr/bin/luac; fi \
            ;; \
        esac \
    && if [ ! -e /usr/bin/luarocks ]; then ln -sf $(which luarocks-${LUAMAJMIN}) /usr/bin/luarocks; fi \
    && if [ ! -e /usr/bin/luarocks-admin ]; then ln -sf $(which luarocks-admin-${LUAMAJMIN}) /usr/bin/luarocks-admin; fi \
    # && apk add --no-cache --virtual .build-deps build-base unzip \
    # && cd /tmp \
    # && git clone https://github.com/keplerproject/luarocks.git \
    # && cd luarocks \
    # && sh ./configure \
    # && make build install \
    # && cd \
    # && apk del --purge .build-deps \
    && rm -rf /var/cache/apk/* /tmp/* /root/.cache/luarocks
#
COPY root/ /
#
ENTRYPOINT ["/usershell"]
CMD ["lua", "-v"]
