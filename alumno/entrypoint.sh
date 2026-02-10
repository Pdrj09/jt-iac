#!/bin/bash

echo "root:${SSH_PASSWORD:-formacion}" | chpasswd

mkdir -p /run/sshd
ssh-keygen -A

dockerd --host=unix:///var/run/docker.sock &

echo "Esperando a docker..."
for i in $(seq 1 30); do
    if docker info &>/dev/null; then
        echo "ready ;)"
        break
    fi 
        sleep 1
done

nginx

exec /usr/sbin/sshd -D
