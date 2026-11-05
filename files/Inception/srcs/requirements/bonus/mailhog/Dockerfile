FROM debian:bookworm

RUN apt-get update && apt-get install -y curl ca-certificates unzip && rm -rf /var/lib/apt/lists/*

RUN curl -Lo /usr/local/bin/mailhog https://github.com/mailhog/MailHog/releases/latest/download/MailHog_linux_amd64 \
    && chmod +x /usr/local/bin/mailhog


CMD ["mailhog"]
