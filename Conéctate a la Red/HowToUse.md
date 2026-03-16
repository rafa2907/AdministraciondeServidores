# Administrador de Redes Interactivo en Bash

Este script de shell de Linux proporciona una interfaz interactiva para administrar, configurar y conectar interfaces de red, tanto cableadas como inalámbricas.

## Características principales
* **Mostrar Interfaces:** Lista las tarjetas de red disponibles en el sistema y su estado actual.
* **Cambiar Estado:** Permite levantar (UP) o bajar (DOWN) cualquier interfaz de red.
* **Conexión:** * Configuración de redes cableadas (con soporte para IP Estática o Dinámica vía DHCP).
  * Escaneo y conexión a redes inalámbricas (Wi-Fi), detectando automáticamente redes abiertas o seguras (WPA/WPA2/WPA3).
* **Persistencia:** Guarda los perfiles de conexión para que se inicien automáticamente al arrancar el sistema.

## Requisitos previos (Dependencias)
Para que el script funcione correctamente en distribuciones modernas (como Arch Linux o Debian), requiere las siguientes herramientas estándar:
* `iproute2` (Comando `ip` - preinstalado en casi todas las distros).
* `NetworkManager` (Comando `nmcli` - necesario para la gestión de Wi-Fi y persistencia).
* `dhclient` o similar (para solicitar IPs dinámicas).

## Instrucciones de Uso

1. **Dar permisos de ejecución:**
   Antes de usarlo por primera vez, se deben asignar permisos de ejecución:
   
   chmod +x NOMBRE_ARCHIVO.sh
