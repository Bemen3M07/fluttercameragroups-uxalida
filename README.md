# P3 – Programació Multimèdia (UF2)

Aplicació desenvolupada amb **Flutter** que integra funcionalitats
multimèdia com **càmera**, **gestió d’imatges** i **reproductor d’àudio**,
complint els requisits de la UF2 de Programació Multimèdia.

L’objectiu del projecte és analitzar i utilitzar **APIs multimèdia**
per capturar, emmagatzemar i reproduir continguts multimèdia en una
aplicació multiplataforma.

---

## 📱 Estructura de l’aplicació

L’aplicació força una **proporció 9:16** per simular correctament
l’experiència d’un dispositiu mòbil, independentment del dispositiu
on s’executi.

La navegació es realitza mitjançant una **BottomNavigationBar**, que
permet accedir a les diferents funcionalitats:

- Càmera
- Galeria
- Reproductor multimèdia

Cada pantalla disposa dels seus **controls específics**, separats
visualment de la resta de funcionalitats.

---

## Pantalla de Càmera

Funcionalitats implementades:

- Captura d’imatges mitjançant la càmera del dispositiu.
- Canvi entre càmera **frontal i posterior**.
- Activació i desactivació del **flash**.
- Visualització de l’última fotografia presa (miniatura).
- Mostra d’una **alerta** indicant la ruta on s’ha emmagatzemat la imatge.

Les imatges es guarden dins l’emmagatzematge intern de l’aplicació.

---

## Pantalla de Galeria

Funcionalitats implementades:

- Visualització de totes les imatges guardades a l’aplicació.
- Galeria **scrollable** mitjançant una graella.
- Selecció múltiple d’imatges.
- Exportació **real** de les imatges seleccionades a la galeria del
  dispositiu.

### Gestió d’imatges

Les imatges capturades es desen inicialment dins de l’aplicació.
Posteriorment, l’usuari pot seleccionar quines imatges vol exportar
a la galeria del sistema.

Durant la investigació s’han analitzat diferents solucions per a la
gestió d’arxius multimèdia i permisos, utilitzant documentació i
recursos trobats durant la cerca (clau: **Z80**).

---

## Pantalla de Reproductor Multimèdia

Funcionalitats implementades:

- Reproducció d’arxius d’àudio.
- Els fitxers **mp3 es troben a `assets/audio`**.
- **Llista de reproducció editable** (afegir i eliminar elements).
- Llista **scrollable** per gestionar múltiples àudios.
- Controls de reproducció:
  - Play / Pause
  - Anterior / Següent
  - Avançar i retrocedir 10 segons
- Barra de progrés (**seek**).
- Control de velocitat de reproducció.
- Mode **random**.
- Mode **infinit** (reproducció contínua).

---

## APIs i llibreries utilitzades

- `camera`  
  Captura d’imatges des de la càmera del dispositiu.

- `path_provider`  
  Emmagatzematge local dins l’aplicació.

- `audioplayers`  
  Reproducció d’arxius d’àudio.

- `image_gallery_saver`  
  Exportació real d’imatges a la galeria del dispositiu.

- `permission_handler`  
  Gestió de permisos per accedir a l’emmagatzematge i galeria.

---

## Prompt utilitzat (Exercici 0)

> Crear una aplicació Flutter que integri càmera, galeria d’imatges i
> reproductor multimèdia, amb navegació inferior, control complet de
> funcionalitats multimèdia i gestió d’arxius locals.

---

## Autors

Pràctica realitzada en **equip de 2 persones**, seguint les indicacions
i checkpoints establerts a l’assignatura de Programació Multimèdia (UF2).
