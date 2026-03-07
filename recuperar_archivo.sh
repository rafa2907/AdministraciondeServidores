#!/bin/bash

papelera="$HOME/.papelera"
mkdir -p "$papelera"


if [ -f "$papelera/$1" ]; then

	echo "Se esta recuperando el archivo al directorio actual..."

	if [ -f "./$1" ]; then
	
		echo "El archivo ya existe en el directorio actual."
		read -p "¿Desea reemplazarlo? (y/n): " respuesta
		
		if [ "$respuesta" == "y" ]; then
			mv "$papelera/$1" "."
			echo "Se recuperó correctamente"
		else
			echo "No se recuperó el archivo ni se reemplazó."
		fi
		
	else
		mv "$papelera/$1" "."
		echo "Se recuperó correctamente."
	fi
else
	echo "El archivo no existe en la papelera"
fi
