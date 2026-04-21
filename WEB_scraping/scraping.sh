import requests
import re
from bs4 import BeautifulSoup, Comment


url = input("Ingrese el URL: ")

headers = {'User-Agent': 'Mozilla/5.0'}

try:


    respuesta = requests.get(url, headers=headers, timeout=10)



    sopa = BeautifulSoup(respuesta.content, "html.parser")


    comentarios = sopa.find_all(string=lambda text: isinstance(text, Comment))

    patron_correos = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
    correos = re.findall(patron_correos, respuesta.text)


    with open("extraccion_web.txt", "w", encoding="utf-8") as f:
        f.write(f"RESULTADOS PARA: {url}\n")
        f.write("="*30 + "\n\n")

        f.write(f"COMENTARIOS ({len(comentarios)})\n")
        for c in comentarios:
            f.write(f"-> {c.strip()}\n")

        f.write(f"\nCORREOS ENCONTRADOS ({len(correos)})\n")
        for mail in correos:
            f.write(f"-> {mail}\n")

    print("Archivo 'extraccion_web.txt' generado.")

except Exception as e:
    print(f"Hubo un error: {e}")

