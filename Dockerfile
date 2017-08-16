FROM alankent/m2dev
MAINTAINER Alan Kent <alan.james.kent@gmail.com>
ARG MAGENTO_REPO_USERNAME
ARG MAGENTO_REPO_PASSWORD

# Install Luma code and pre-loaded database.
ENV MAGENTO_REPO_USERNAME "$MAGENTO_REPO_USERNAME"
ENV MAGENTO_REPO_PASSWORD "$MAGENTO_REPO_PASSWORD"

ENV MYSQL_ROOT_PASSWORD ""
ENV MYSQL_ALLOW_EMPTY_PASSWORD true
ENV MYSQL_DATABASE magento
ENV MYSQL_USER magento
ENV MYSQL_PASSWORD magento

ENV MAGENTO_USER magento
ENV MAGENTO_PASSWORD magento
ENV MAGENTO_GROUP magento

ENV APACHE_RUN_USER magento
ENV APACHE_RUN_GROUP magento

RUN sh -x /scripts/install-luma
ENV MAGENTO_REPO_USERNAME ""
ENV MAGENTO_REPO_PASSWORD ""

# Add some helper modules (optional)
ADD AlanKent /magento2/app/code/AlanKent
RUN chown -R magento:magento /magento2/app/code/AlanKent
RUN /usr/local/bin/mysql.server start \
 && sudo -u magento sh -c '/magento2/bin/magento setup:upgrade' \
 && rm -rf /magento2/var/* \
 && /usr/local/bin/mysql.server stop

# Add mount volume points, but often not used.
VOLUME /magento2/app/code
VOLUME /magento2/app/design
VOLUME /magento2/app/i18n

