FROM ubuntu:16.04
RUN apt-get update && \
    apt-get -y --no-install-recommends install libxml2-utils && \
    apt-get autoremove -y && \
    apt-get clean
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
