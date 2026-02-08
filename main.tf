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

resource "docker_network" "jf-tic" {
    name = "jf-tic-net"
    driver = "maclan"

    options = {
        parent = var.network_interface
    }

    ipam_config {
        subnet = var.network_subnet
        gateway = var.network_gateway
    }
  
}