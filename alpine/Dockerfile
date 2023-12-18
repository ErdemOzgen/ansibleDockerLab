FROM alpine:latest
LABEL AUTHOR "ErdemOzgen"

# Install packages
RUN apk update && apk add vim curl wget py3-pip openssh sudo net-tools iputils jq nano

# Create ANSUSER, .ssh directory and set ownsership,permission
RUN adduser -D ansuser -s /bin/sh -G wheel \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "ansuser ALL=(ALL) NOPASSWD: ALL " >> /etc/sudoers \
    && mkdir -p /var/run/sshd

# Copy entrypoint script
COPY script/entrypoint.sh /usr/local/bin
RUN chmod u+x /usr/local/bin/entrypoint.sh

# Set root user and ansuser password
RUN echo "root:password123" | chpasswd
RUN echo "ansuser:password123" | chpasswd

# SSHD will listen at port 22
EXPOSE 22

# Start SSHD service
ENTRYPOINT ["entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]
