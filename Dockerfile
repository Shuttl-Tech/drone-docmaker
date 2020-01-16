FROM squidfunk/mkdocs-material:latest

ADD parse-creds.py /usr/local/bin/parse-creds
ADD plugin.sh /plugin
RUN chmod +x /usr/local/bin/parse-creds /plugin

ENTRYPOINT ["/plugin"]
