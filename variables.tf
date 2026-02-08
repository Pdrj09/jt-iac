# --- lista de alumnos ---

variable "alumnos" {
    description = "Lista de alumnos que estan en la formacion"
    type = map(string)

    default = {
      "alumno1" = "192.168.1.201"
      "alumno2" = "192.168.1.202"
      "alumno3" = "192.168.1.203"
    }
  
}


# --- Red macvlan ---

variable "network_interface" {
    description = "Interfaz red fisica a la que se conectara"
    type = string
    default = "enp3s0"
  
}

variable "network_subnet" {
    description = "Subnet de la red local"
    type = string
    default = "192.168.1.0/24"
}

variable "network_gateway" {
    description = "Puerta de enlace (router)"
    type = string
    default = "192.168.1.1"  
}