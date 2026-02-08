output "conexiones" {
    description = "Datos de conexión de cada alumno"
    value = {
        for nombre, ip in var.alumnos : nombre => {
            ssh  = "ssh root@${ip}"
            web  = "http://${ip}"
            pass = var.ssh_password
        }
    }
    sensitive = true
}

output "resumen" {
    description = "Tabla rápida de conexiones"
    value = join("\n", concat(
        [
            "╔════════════════╦══════════════════╦════════════════════╗",
            "║    Alumno      ║ IP               ║ SSH                ║",
            "╠════════════════╬══════════════════╬════════════════════╣",
        ],
        [
            for nombre, ip in var.alumnos :
            "║ ${format("%-14s", nombre)} ║ ${format("%-16s", ip)} ║ ssh root@${format("%-8s", ip)} ║"
        ],
        [
            "╚════════════════╩══════════════════╩════════════════════╝",
            "",
            "Contraseña: ${var.ssh_password}",
            "Web: http://IP_DEL_ALUMNO (puerto 80 estándar)",
        ]
    ))
    sensitive = true
}
