# Use CentOS as the base image
FROM centos:latest
LABEL AUTHOR "ErdemOzgen"

# Install packages using yum
RUN yum update -y && yum install -y vim curl wget python3 python3-pip openssh-server sshpass sudo which locate net-tools iputils bind-utils jq nano

# Create ANSUSER, .ssh directory and set ownership, permission
RUN useradd -ms /bin/bash ansuser \
    && usermod -aG wheel ansuser \
    && echo "ansuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && mkdir -p /home/ansuser/.ssh/ /var/run/sshd \
    && chown -R ansuser:ansuser /home/ansuser/.ssh/ \
    && chmod 700 /home/ansuser/.ssh/

# Set root user and ansuser password
RUN echo "root:password123" | chpasswd \
    && echo "ansuser:password123" | chpasswd

# This bootstrap script will install ansible, generate/distribute ssh keys and run sample ansible command to test connectivity.
COPY ["script/bootstrap.sh", "/home/ansuser/"]

# Allow root to login via SSH
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "export PATH=/home/ansuser/.local/bin:${PATH}" >> /home/ansuser/.bashrc \
    && chown ansuser:ansuser /home/ansuser/bootstrap.sh

# SSHD will listen at port 22
EXPOSE 22

# Run SSHD service on startup
CMD ["/usr/sbin/sshd", "-D"]
