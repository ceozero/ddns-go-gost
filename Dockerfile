# Final stage: Use Alpine as base image
FROM alpine:3.20

# Install necessary packages
RUN apk add --no-cache iptables curl ca-certificates tzdata tini && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

WORKDIR /app

# Download and extract ddns-go binary
RUN curl -L -o /app/ddns-go.tar.gz https://github.com/jeessy2/ddns-go/releases/download/v6.7.2/ddns-go_6.7.2_linux_x86_64.tar.gz && \
    tar -xzf /app/ddns-go.tar.gz -C /app && \
    chmod +x /app/ddns-go

# Download and extract gost binary
RUN curl -L -o /app/gost.tar.gz https://github.com/ginuerzh/gost/releases/download/v2.12.0/gost_2.12.0_linux_amd64.tar.gz && \
    tar -xzf /app/gost.tar.gz -C /app && \
    chmod +x /app/gost

# Download and extract realm binary
RUN curl -L -o /app/realm.tar.gz https://github.com/zhboner/realm/releases/download/v2.6.3/realm-x86_64-unknown-linux-musl.tar.gz && \
    tar -xzf /app/realm.tar.gz -C /app && \
    chmod +x /app/realm

# Expose ports for applications as needed
EXPOSE 9876

# Define entrypoints and default commands using Tini as init system
ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/bin/sh", "-c", "/app/ddns-go -l :9876 -f 300 & /app/gost -C /root/gost.json & /app/realm -c /root/realm.toml"]


#docker build -t ddns-go-gost .
