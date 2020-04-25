FROM alpine:latest
MAINTAINER Allen <liupengliang1012@gmail.com>

ENV HUGO_VERSION=0.69.0

# Install Hugo
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz /tmp
RUN apk add --no-cache py-pygments ca-certificates \
    && cd /tmp \
    && tar -xf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz hugo \
    && mv /tmp/hugo /usr/local/bin/hugo \
    && rm -rf /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

# Decide working directory
WORKDIR /hugo-site

# Mount volume to host
VOLUME /hugo-site
VOLUME /static-site

# Expose default hugo port
EXPOSE 1313

# # By default, serve site
#ENV HUGO_BASE_URL http://localhost:1313
#CMD hugo server -b ${HUGO_BASE_URL} --bind=0.0.0.0 --disableFastRender
#CMD ["/bin/sh"]

#COPY start.sh /start.sh
#CMD ["/start.sh"]


