#!/bin/bash

# Crear usuario del alumno
useradd -m -s /bin/bash "${ALUMNO}"
echo "${ALUMNO}:${SSH_PASSWORD:-formacion}" | chpasswd
usermod -aG sudo,docker "${ALUMNO}"
echo "${ALUMNO} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${ALUMNO}

# Password de root (para sudo manual si hace falta)
echo "root:${SSH_PASSWORD:-formacion}" | chpasswd

# SSH host keys
ssh-keygen -A
mkdir -p /run/sshd

# Arrancar systemd como PID 1
exec /sbin/init
