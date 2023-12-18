FROM ubuntu:latest
LABEL AUTHOR "ErdemOzgen"

# Install packages
RUN apt update && apt install -y vim curl wget python3 python3-pip openssh-server sshpass sudo locate net-tools iputils-ping jq nano

# Create ANSUSER, .ssh directory and set ownsership,permission
RUN useradd -ms /bin/bash ansuser \
    && usermod -aG sudo ansuser \
    && touch ~/.hushlogin /home/ansuser/.hushlogin \
    && mkdir /home/ansuser/.ssh/ /var/run/sshd \
    && chown -R ansuser:ansuser /home/ansuser/.ssh/ \
    && chmod u=rwx /home/ansuser/.ssh/ \
    && echo "ansuser ALL=(ALL) NOPASSWD: ALL " >> /etc/sudoers

# Set root user and ansuser password
RUN echo "root:password123" | chpasswd
RUN echo "ansuser:password123" | chpasswd

# This bootstrap script will install ansible, generate/distribute ssh keys and run sameple ansible command to test connectivity.
COPY ["script/bootstrap.sh", "/home/ansuser/"]

# Allow root to login via SSH
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "export PATH=/home/ansuser/.local/bin:${PATH}" >> /home/ansuser/.bashrc \
    && chown ansuser:ansuser /home/ansuser/bootstrap.sh

# SSHD will listen at port 22
EXPOSE 22

# Run SSHD service on startup
CMD ["/usr/sbin/sshd","-D"]
