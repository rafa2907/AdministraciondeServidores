#!/bin/bash

papelera="$HOME/.papelera"

mkdir -p "$papelera"





if [ -f "$papelera/$1" ]; then
	echo "archivo ya existente en papelera"
	read -p "Desea reemplzarlo? (y/n): " respuesta

	if [ "$respuesta" == "y" ]; then
		echo "reemplazando archivo..."
		mv "$1" "$papelera"

		echo "Se eliminó correctamente."
	else
		echo "No se reemplazo ni se eliminó el archivo"
	fi
else
	mv "$1" "$papelera"
	
fi
	
	
