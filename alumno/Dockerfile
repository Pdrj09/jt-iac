FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# ---- paquetes base + systemd -----
RUN apt-get update && apt-get install -y \
    systemd \
    systemd-sysv \
    openssh-server \
    nginx \
    curl \
    wget \
    vim \
    net-tools \
    iputils-ping \
    dnsutils \
    htop \
    tree \
    git \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    certbot \
    && rm -rf /var/lib/apt/lists/*

# Limpiar units de systemd que no hacen falta en Docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ "$i" = "systemd-tmpfiles-setup.service" ] || rm -f "$i"; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*

# Instalacion de Docker
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
      > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# conf ssh
RUN mkdir -p /run/sshd && \
    ssh-keygen -A && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Nginx: config base
RUN rm -f /etc/nginx/sites-enabled/default
RUN echo 'worker_processes auto;\n\
events { worker_connections 1024; }\n\
http {\n\
    include /etc/nginx/mime.types;\n\
    default_type application/octet-stream;\n\
    sendfile on;\n\
    keepalive_timeout 65;\n\
    include /etc/nginx/sites-enabled/*;\n\
}' > /etc/nginx/nginx.conf

# Nginx: site por defecto para que escuche en el 80
RUN echo 'server {\n\
    listen 80 default_server;\n\
    root /var/www/html;\n\
    index index.html;\n\
    server_name _;\n\
    location / {\n\
        try_files $uri $uri/ =404;\n\
    }\n\
}' > /etc/nginx/sites-enabled/default.conf

# Pagina web por defecto
RUN mkdir -p /var/www/html && \
    echo '<h1>Formacion</h1>' > /var/www/html/index.html

# Habilitar servicios para systemd
RUN systemctl enable ssh nginx docker

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 80 443

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT ["/entrypoint.sh"]
