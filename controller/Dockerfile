FROM python:3.14.6-trixie

LABEL org.opencontainers.image.authors="ErdemOzgen"
LABEL org.opencontainers.image.description="Pinned Ansible controller for the Ansible Docker lab"

ENV ANSIBLE_CONFIG=/workspace/ansible.cfg
ENV PIP_NO_CACHE_DIR=1
ENV PYTHONDONTWRITEBYTECODE=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        curl \
        git \
        iproute2 \
        iputils-ping \
        jq \
        less \
        make \
        nano \
        net-tools \
        openssh-client \
        openssh-server \
        sshpass \
        sudo \
        vim \
        wget \
    && rm -rf /var/lib/apt/lists/*

COPY requirements-controller.txt /tmp/requirements-controller.txt
RUN python -m pip install --requirement /tmp/requirements-controller.txt

RUN useradd --create-home --shell /bin/bash ansuser \
    && usermod --append --groups sudo ansuser \
    && install -d -m 700 -o ansuser -g ansuser /home/ansuser/.ssh \
    && install -d -m 755 /run/sshd /var/run/sshd /workspace \
    && touch /home/ansuser/.hushlogin \
    && chown ansuser:ansuser /home/ansuser/.hushlogin /workspace \
    && echo "ansuser ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/ansuser \
    && chmod 440 /etc/sudoers.d/ansuser \
    && echo "root:password123" | chpasswd \
    && echo "ansuser:password123" | chpasswd \
    && printf '%s\n' \
        "PasswordAuthentication yes" \
        "PermitRootLogin yes" \
        "UsePAM yes" \
        >>/etc/ssh/sshd_config

COPY --chown=ansuser:ansuser ansible.cfg /workspace/ansible.cfg
COPY --chown=ansuser:ansuser inventory /workspace/inventory
COPY --chown=ansuser:ansuser playbooks /workspace/playbooks
COPY --chown=ansuser:ansuser script/bootstrap.sh /workspace/script/bootstrap.sh
COPY script/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh /workspace/script/bootstrap.sh

WORKDIR /workspace

EXPOSE 22

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e"]
