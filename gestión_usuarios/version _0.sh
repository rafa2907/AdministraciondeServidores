#!/bin/bash


read -r -p "Ingrese nombre del nuevo usuario: " nombre_usuario
read -r -p "Ingrese el nombre completo del nuevo usuario: " nombre_completo

useradd -m -c "$nombre_completo" "$nombre_usuario"


if [ $? -ne 0 ]; then
    echo "Error: No se pudo crear al usuario o ejecutar como root"
    exit 1
fi

echo "Usuario $nombre_usuario creado."
echo ""
echo "Configuración de Contraseña"


while true; do
    read -s -r -p "Ingresa la contraseña para $nombre_usuario: " password
    echo "" 

    if [ ${#password} -le 8 ]; then
        echo "Error: La contraseña debe tener MÁS de 8 caracteres."
        continue
    fi

    if [[ ! "$password" =~ [A-Z] ]]; then
        echo "Error: Debe incluir al menos una letra mayúscula."
        continue
    fi

    if [[ ! "$password" =~ [[:punct:]] ]]; then
        echo "Error: Debe incluir al menos un símbolo especial."
        continue
    fi

    if [[ ! "$password" =~ [0-9] ]]; then
		echo "Error: Debe incluir al menos un número."
		continue
    fi

    
    echo "Contraseña válida. Aplicando al sistema..."
    break
done


echo "$nombre_usuario:$password" | chpasswd

if [ $? -eq 0 ]; then
    echo "¡Éxito! El usuario $nombre_usuario ha sido configurado completamente."
else
    echo "Error al asignar la contraseña."
fi
