FROM alpine

# Uncomment this section if you need to use glibc in your container, f.e. when you enable CGO_ENABLED=1
# Set locale
#ENV LANG=C.UTF-8
#
# Install glibc so that CGO can be enabled when using dynamic linking
#RUN apk add --no-cache --virtual .build-deps curl \
#    && GLIBC_VER="2.31-r0" \
#    && ALPINE_GLIBC_REPO="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" \
#    && curl -LfsS https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
#    && SGERRAND_RSA_SHA256="823b54589c93b02497f1ba4dc622eaef9c813e6b0f0ebbb2f771e32adf9f4ef2" \
#    && echo "${SGERRAND_RSA_SHA256} */etc/apk/keys/sgerrand.rsa.pub" | sha256sum -c - \
#    && curl -LfsS ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-${GLIBC_VER}.apk > /tmp/glibc-${GLIBC_VER}.apk \
#    && apk add --no-cache /tmp/glibc-${GLIBC_VER}.apk \
#    && curl -LfsS ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk > /tmp/glibc-bin-${GLIBC_VER}.apk \
#    && apk add --no-cache /tmp/glibc-bin-${GLIBC_VER}.apk \
#    && curl -Ls ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk > /tmp/glibc-i18n-${GLIBC_VER}.apk \
#    && apk add --no-cache /tmp/glibc-i18n-${GLIBC_VER}.apk \
#    && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
#    && echo "export LANG=$LANG" > /etc/profile.d/locale.sh \
#    && apk del --purge .build-deps glibc-i18n \
#    && rm -rf /tmp/*.apk /var/cache/apk/*

COPY app_linux_amd64 app_linux_amd64

RUN apk update  && \
    apk -i upgrade && \
    apk cache clean

EXPOSE 8080

CMD ["./app_linux_amd64"]
