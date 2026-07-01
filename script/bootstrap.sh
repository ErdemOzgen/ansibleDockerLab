#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${PROJECT_DIR:-/workspace}"
LAB_USER="${ANSIBLE_LAB_USER:-ansuser}"
LAB_PASSWORD="${ANSIBLE_LAB_PASSWORD:-password123}"
SSH_DIR="${HOME}/.ssh"
SSH_KEY="${SSH_DIR}/id_ed25519"
MANAGED_HOSTS=(ansubuntu ansalpine ansrocky)

mkdir -p "${SSH_DIR}"
chmod 700 "${SSH_DIR}"

if [[ ! -f "${SSH_KEY}" ]]; then
    echo "++ Generating SSH key for ${LAB_USER}"
    ssh-keygen -t ed25519 -f "${SSH_KEY}" -N "" -q -C "ansible-lab@anscontroller"
fi

for host in "${MANAGED_HOSTS[@]}"; do
    echo "++ Installing controller SSH key on ${host}"
    ssh-keygen -R "${host}" >/dev/null 2>&1 || true
    sshpass -p "${LAB_PASSWORD}" ssh-copy-id \
        -f \
        -i "${SSH_KEY}.pub" \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "${LAB_USER}@${host}"
done

cd "${PROJECT_DIR}"

echo "++ Verifying Ansible connectivity"
ansible managed -m ping
