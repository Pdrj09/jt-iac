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
# |      CONTENEDOR ALUMNO               |
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
