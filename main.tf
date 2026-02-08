terraform {
  required_version = ">= 1.6.0"

  required_providers {
    docker = {
        source = "kreuzwerker/docker"
        version = "~> 3.0"
    }
  }
}

provider "docker" {
    host = "unix:///var/run/docker.sock" # socket de docker 
}

# ------------------------------------------
# |           RED MACVLAN                   |
# |  Cada contenedor tiene IP propia en la  |
# |  red local, como si fuera otra máquina  |
# ------------------------------------------

resource "docker_network" "jf-tic" {
    name = "jf-tic-net"
    driver = "macvlan"

    options = {
        parent = var.network_interface
    }

    ipam_config {
        subnet = var.network_subnet
        gateway = var.network_gateway
    }
  
}

#  --------------------------------------
# |      IMAGEN DEL ALUMNO               |
# | Contenedor creado para cada alumno,  |
# | cada uno configurado para montar un  |
# | docker in docker y con un nginx      |
#  --------------------------------------

resource "docker_image" "alumno" {
    name = "alunmno-container"

    build {
        context = "${path.module}/alumno"
        tag = ["formacion-alumno:latest"]
    }

    triggers = {
        dockerfile = filemd5("${path.module}/alumno/Dockerfile")
        entrypoint = filemd5("${path.module}/alumno/entrypoint.sh")
    }
}

locals {
  alumnos_list = [for nombre, ip in var.alumnos : {nombre = nombre, ip = ip}]
}

#  --------------------------------------
# |          CONTENEDOR ALUMNO           |
#  --------------------------------------

resource "docker_container" "alumno" {
    count = length(local.alumnos_list)
    name = "formacion-${local.alumnos_list[count.index].nombre}"
    image = docker_image.alumno.image_id

    privileged = true

    env = [
        "SSH_PASSWORD=${var.ssh_password}",
        "ALUMNO=${local.alumnos_list[count.index].nombre}",    
    ]

    networks_advanced {
        name = docker_network.jf-tic.name
        ipv4_address = local.alumnos_list[count.index].ip
        aliases = [local.alumnos_list[count.index].nombre]
    }

    volumes {
        volume_name = docker_volume.docker_data[count.index].name
        container_path = "/var/lib/docker"
    }

    restart = "unless-stopped"

    tmpfs = {
        "/tmp" = ""
        "/run" = ""
        "/run/lock" = ""
    }
}

# Volumnes por alumnos 
resource "docker_volume" "docker_data" {
  count = length(local.alumnos_list)
  name  = "formacion-docker-${local.alumnos_list[count.index].nombre}"
}