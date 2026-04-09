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

    if [[ ! "$password" =~ [1-9] ]]; then
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


echo "¿Desea asignar una cuota de disco a este usuario? (y/n)"
read -r asignar_cuota

if [[ "$asignar_cuota" == "y" || "$asignar_cuota" == "Y" ]]; then


	read -r -p "Ingresa el límite Soft en KB: " soft_kb
    read -r -p "Ingresa el límite duro (Hard Limit) en KB: " hard_kb

    
    if [[ "$soft_kb" =~ ^[0-9]+$ ]] && [[ "$hard_kb" =~ ^[0-9]+$ ]]; then
        
        setquota -u "$nombre_usuario" "$soft_kb" "$hard_kb" 0 0 /home

		if [ $? -eq 0 ]; then
            echo "Cuota asignada: Soft=${soft_kb}KB, Hard=${hard_kb}KB."
        else
            echo "Error al asignar las cuotas. (Asegúrate de que el paquete: quota este instalado."
        fi

        
    else
        echo "Los límites ingresados no son números válidos. Omitiendo cuotas."
    fi

    
else
    echo "Omitiendo la asignación de cuotas."


fi


echo ""
read -r -p "¿Deseas cambiar el periodo de gracia para las cuotas? (y/n): " cambiar_gracia
        
if [[ "$cambiar_gracia" == "y" || "$cambiar_gracia" == "Y" ]]; then
    read -r -p "Ingresa el nuevo periodo de gracia en DÍAS: " dias_gracia
            
    if [[ "$dias_gracia" =~ ^[0-9]+$ ]]; then
                        
    	segundos=$((dias_gracia * 86400))
                
        setquota -t "$segundos" "$segundos" /home
                
        if [ $? -eq 0 ]; then
        	echo "Periodo de gracia actualizado a $dias_gracia días (Global para /home)."
        else
        	echo "Error al actualizar el periodo de gracia."
        fi
	else
    	echo "Error: Debes ingresar un número válido. Omitiendo periodo de gracia."
    fi
fi
