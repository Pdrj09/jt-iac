# --- lista de alumnos ---

variable "alumnos" {
    description = "Lista de alumnos que estan en la formacion"
    type = map(string)

    default = {
      "alumno1" = "192.168.0.201"
      "alumno2" = "192.168.0.202"
      "alumno3" = "192.168.0.203"
    }
  
}

variable "ssh_password" {
    description = "Contraseña para la conexion por ssh"
    type = string
    sensitive = true
    default = "formacion"
}


# --- Red macvlan ---

variable "network_interface" {
    description = "Interfaz red fisica a la que se conectara"
    type = string
    default = "wlp98s0"
  
}

variable "network_subnet" {
    description = "Subnet de la red local"
    type = string
    default = "192.168.0.0/24"
}

variable "network_gateway" {
    description = "Puerta de enlace (router)"
    type = string
    default = "192.168.0.1"  
}