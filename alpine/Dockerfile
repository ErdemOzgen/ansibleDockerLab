FROM alpine:3.24

LABEL org.opencontainers.image.authors="ErdemOzgen"
LABEL org.opencontainers.image.description="Alpine managed node for the Ansible Docker lab"

RUN apk add --no-cache \
        bash \
        curl \
        iproute2 \
        iputils \
        jq \
        nano \
        net-tools \
        openssh \
        python3 \
        sudo \
        vim \
        wget

RUN adduser -D -s /bin/sh -G wheel ansuser \
    && install -d -m 700 -o ansuser -g ansuser /home/ansuser/.ssh \
    && install -d -m 755 /run/sshd /var/run/sshd \
    && echo "ansuser ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/ansuser \
    && chmod 440 /etc/sudoers.d/ansuser \
    && echo "root:password123" | chpasswd \
    && echo "ansuser:password123" | chpasswd \
    && printf '%s\n' \
        "PasswordAuthentication yes" \
        "PermitRootLogin yes" \
        >>/etc/ssh/sshd_config

COPY script/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e"]
