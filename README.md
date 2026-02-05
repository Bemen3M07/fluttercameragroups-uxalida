# P3 – Programació Multimèdia (UF2)

Aplicació desenvolupada amb Flutter que integra funcionalitats multimèdia
com càmera, gestió d’imatges i reproductor d’àudio, seguint els requisits
de l’UF2 de Programació Multimèdia.

## Pantalles
- **Càmera**:
  - Captura d’imatges.
  - Canvi entre càmera frontal i posterior.
  - Activació i desactivació del flash.
  - Visualització de l’última foto presa.
  - Alerta mostrant la ruta on s’ha desat la imatge.

- **Galeria**:
  - Visualització de les imatges guardades a l’aplicació.
  - Selecció múltiple d’imatges.
  - Exportació real de les imatges seleccionades a la galeria del dispositiu.

- **Reproductor**:
  - Reproducció d’àudio.
  - Llista de reproducció.
  - Mode random i mode infinit.
  - Seek (barra de progrés).
  - Control de velocitat.
  - Avançar i retrocedir 10 segons.

## APIs utilitzades
- `camera`: captura d’imatges des de la càmera del dispositiu.
- `path_provider`: emmagatzematge local dins l’aplicació.
- `audioplayers`: reproducció d’àudio.
- `image_gallery_saver`: exportació real d’imatges a la galeria del dispositiu.
- `permission_handler`: gestió de permisos per a accedir a la galeria/emmagatzematge.

## Gestió d’imatges
Les imatges capturades es guarden dins l’emmagatzematge intern de l’aplicació.
L’usuari pot seleccionar una o més imatges i exportar-les a la galeria del
dispositiu de forma real (clau: Sinclair).

Durant la investigació es van analitzar diverses solucions per a la gestió
d’arxius multimèdia i exportació a galeria del sistema, utilitzant recursos
i documentació trobats durant la cerca (clau: Z80).

## Controls i interfície
Cada pantalla disposa dels seus propis controls específics (càmera, galeria
i reproductor), separats visualment, i l’aplicació utilitza una
BottomNavigationBar per navegar entre funcionalitats.

## Prompt
Crear una aplicació Flutter amb càmera, galeria i reproductor multimèdia,
amb navegació inferior, control complet de funcionalitats i gestió
d’arxius multimèdia.

## Autors
Pràctica realitzada en equip de 2 persones.


que los mp3 están en assets/audio

que la lista es editable

que es scrollable

que se fuerza proporción 9:16