#!/bin/bash

echo "=== DIAGNÓSTICO RED MACVLAN ==="
echo ""

echo "1. Contenedores corriendo:"
sudo docker ps --filter "name=formacion-" --format "table {{.Names}}\t{{.Status}}"
echo ""

echo "2. IPs asignadas a los contenedores:"
for container in $(sudo docker ps --filter "name=formacion-" --format "{{.Names}}"); do
    ip=$(sudo docker inspect $container | grep -A 1 '"jf-tic-net"' | grep '"IPAddress"' | cut -d'"' -f4)
    echo "  $container -> $ip"
done
echo ""

echo "3. Ping desde el HOST a los contenedores:"
for ip in 192.168.0.201 192.168.0.202 192.168.0.203; do
    echo -n "  Ping a $ip: "
    ping -c 1 -W 1 $ip &>/dev/null && echo "✓ OK" || echo "✗ FALLO"
done
echo ""

echo "4. Verificar red macvlan:"
sudo docker network inspect jf-tic-net | grep -E '"Driver"|"parent"|"Subnet"|"Gateway"'
echo ""

echo "5. Interfaz física (enp3s0):"
ip addr show enp3s0 2>/dev/null || echo "  Interfaz enp3s0 no encontrada"
echo ""

echo "6. Tabla ARP (dispositivos visibles en la red):"
ip neigh | grep "192.168.0.20"
echo ""

echo "7. Logs del primer contenedor:"
sudo docker logs --tail 20 formacion-alumno1 2>/dev/null || echo "  Contenedor no encontrado"
