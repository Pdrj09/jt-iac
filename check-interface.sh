#!/bin/bash

echo "=== INTERFACES DE RED DISPONIBLES ==="
echo ""
ip -br addr show | grep -v "lo\|docker\|br-"
echo ""
echo "=== ¿Cuál es tu interfaz principal? ==="
echo ""
echo "Buscando interfaz con conexión a 192.168.0.x:"
ip route | grep "192.168.0"
