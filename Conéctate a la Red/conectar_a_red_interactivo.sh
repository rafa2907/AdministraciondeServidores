#!/bin/bash


function mostrar_interfaces() {
    ip a
}

function cambiar_estado() {
	echo -n "Ingresa el nombre de la interfaz a modificar (ej. enp0s3, wlan0): "
    read -r interfaz

	if [ ! -d "/sys/class/net/$interfaz" ]; then
        echo "Error: La interfaz '$interfaz' no existe en este sistema."
        return 1
    fi

    echo "¿Qué deseas hacer con la interfaz '$interfaz'?"
    
    estado_opciones="Subir(UP) Bajar(DOWN) Cancelar"
    
    select est in $estado_opciones; do
        case $est in
            "Subir(UP)")
                ip link set dev "$interfaz" up 2>/dev/null
                if test $? -eq 0; then
                    echo "La interfaz $interfaz ahora está ARRIBA (UP)."
                else
                    echo "Falló al subir la interfaz."
                fi
                break
                ;;
            "Bajar(DOWN)")
                ip link set dev "$interfaz" down 2>/dev/null
                if test $? -eq 0; then
                    echo "La interfaz $interfaz ahora está ABAJO (DOWN)."
                else
                    echo "Falló al bajar la interfaz."
                fi
                break
                ;;
            "Cancelar")
                echo "Operación cancelada."
                break
                ;;
            *)
                echo "Opción no válida. Elige 1, 2 o 3."
                ;;
        esac
    done
}

function conectar_red() {
echo "¿Qué tipo de conexión deseas configurar?"
    opciones_conexion="Cableada Inalámbrica(Wi-Fi) Cancelar"

    select tipo in $opciones_conexion; do
        case $tipo in
            "Cableada")
                echo -n "Ingresa el nombre de la interfaz cableada (ej. enp0s3): "
                read -r interfaz
                
                
                ip link set dev "$interfaz" up 2>/dev/null

                echo "¿Cómo deseas configurar la IP para $interfaz?"
                opciones_ip="Dinámica(DHCP) Estática Cancelar"
                
                select ip_opt in $opciones_ip; do
                    case $ip_opt in
                        "Dinámica(DHCP)")
                            echo "Solicitando IP por DHCP..."
                            
                            dhclient "$interfaz" 2>/dev/null || echo "Asegúrate de tener un cliente DHCP."
                            echo "Configuración dinámica completada."
                            break 2
                            ;;
                        "Estática")
                            echo -n "Ingresa la IP con prefijo (ej. 192.168.1.10/24): "
                            read -r ip_conPrefijo
                            echo -n "Ingresa la IP del Gateway (ej. 192.168.1.254): "
                            read -r gateway

                            
                            ip addr flush dev "$interfaz" 2>/dev/null
                            ip addr add "$ip_conPrefijo" dev "$interfaz"
                            ip route add default via "$gateway"
                            echo "Configuración estática aplicada con éxito."
                            break 2
                            ;;
                        "Cancelar")
                            break 2
                            ;;
                    esac
                done
                ;;
            
            "Inalámbrica(Wi-Fi)")
                echo "Escaneando redes Wi-Fi disponibles..."
                
                nmcli device wifi list

                echo -n "Escribe el SSID (Nombre exacto) de la red a la que te quieres conectar: "
                read -r ssid
                echo -n "Escribe la contraseña (déjalo en blanco si es una red abierta): "
                read -r password

                if [ -z "$password" ]; then
                    echo "Conectando a red abierta..."
                    nmcli device wifi connect "$ssid"
                else
                    echo "Conectando a red segura..."
                    nmcli device wifi connect "$ssid" password "$password"
                fi
                break
                ;;
                
            "Cancelar")
                echo "Operación cancelada."
                break
                ;;
        esac
    done
}

function hacer_permanente() {

	echo "--- Guardar Configuración ---"
    echo "Tus conexiones actuales guardadas son:"
    
    nmcli -t -f NAME connection show
    
    echo ""
    echo -n "Escribe el nombre de la red que deseas hacer permanente (que inicie con el sistema): "
    read -r nombre_red

    
    nmcli connection modify "$nombre_red" connection.autoconnect yes 2>/dev/null

    if test $? -eq 0; then
        echo "La red '$nombre_red' se ha guardado y se conectará automáticamente al reiniciar."
    else
        echo "Error: No se pudo hacer permanente. Verifica que escribiste el nombre exactamente igual."
    fi

}

function salir() {
    echo "Saliendo del administrador de red..."
    exit 0
}








clear
echo "--- Administrador de Red Interactivo ---"


OPCIONES="Mostrar_Interfaces Cambiar_Estado Conectar_Red Guardar_Configuracion Salir"

select opt in $OPCIONES; do
    case $opt in
        "Mostrar_Interfaces")
            mostrar_interfaces
            ;;
        "Cambiar_Estado")
            cambiar_estado
            ;;
        "Conectar_Red")
            conectar_red
            ;;
        "Guardar_Configuracion")
            hacer_permanente
            ;;
        "Salir")
            salir
            ;;
        *)
            echo "Opción no válida. Intenta de nuevo."
            ;;
    esac
done
