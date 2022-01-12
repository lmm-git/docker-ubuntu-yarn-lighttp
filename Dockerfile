FROM ubuntu:impish

# Set noninteractive environment
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
      && apt-get upgrade -y \
      && apt-get install -y curl gnupg2 \
      && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
      && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
      && apt-get update \
      && apt-get install -y lighttpd yarn \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

COPY ./lighttpd.conf etc/lighttpd/lighttpd.conf

RUN chown -R www-data:www-data /var/www

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh && chown www-data:www-data /entrypoint.sh

USER www-data

WORKDIR "/var/www"

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
