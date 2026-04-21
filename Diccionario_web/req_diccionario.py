import requests


def escanear_servidor():

    host = input("Introduce el host (ej. 127.0.0.1): ")
    puerto = input("Introduce el puerto (ej. 8000): ")
    
    url_base = f"http://{host}:{puerto}/"
    
    try:

        with open("diccionario.txt", "r") as archivo:
            lineas = archivo.readlines()
            
        print(f"\n--- Iniciando escaneo en {url_base} ---\n")


        for linea in lineas:
            recurso = linea.strip()
            url_final = url_base + recurso
            
            try:

                respuesta = requests.get(url_final, timeout=5)
                codigo = respuesta.status_code
                

                if 200 <= codigo <= 299:
                    print(f"Código {codigo}: El recurso '{recurso}' SÍ EXISTE.")
                
                elif 400 <= codigo <= 499:
                    print(f"Código {codigo}: El recurso '{recurso}' NO EXISTE en el servidor.")
                
                else:
                    print(f"Código {codigo}: Respuesta inesperada para '{recurso}'.")

            except requests.exceptions.ConnectionError:
                print(f"[ERROR]: No hay conexión con el host {host} en el puerto {puerto}.")
                break

    except FileNotFoundError:
        print("Error: No se encontró el archivo 'diccionario.txt'.")

if __name__ == "__main__":
    escanear_servidor()
