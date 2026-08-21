# 🧹 CleanBRUH

<p align="center">
  <img src="https://raw.githubusercontent.com/pablo96sancho/CleanBRUH/main/github/cover.jpg" alt="CleanBRUH" width="128" />
</p>

<p align="center">
  <strong>Bloquea temporalmente teclado, ratón y trackpad para limpiar tu Mac sin interrupciones.</strong>
</p>

<p align="center">
  <a href="https://github.com/pablo96sancho/CleanBRUH/releases/latest"><img src="https://img.shields.io/github/v/release/pablo96sancho/CleanBRUH?label=Descargar%20para%20macOS&style=for-the-badge" alt="Descargar para macOS"></a>
  <img src="https://img.shields.io/badge/macOS-13%2B-000000?style=for-the-badge&logo=apple" alt="macOS 13 o superior">
</p>

<p align="center">
  <a href="https://github.com/pablo96sancho/CleanBRUH/releases/latest"><strong>Descargar CleanBRUH v1.1</strong></a>
</p>

<img src="https://raw.githubusercontent.com/pablo96sancho/CleanBRUH/main/cover.jpg" alt="Vista previa de CleanBRUH" width="100%">

## Instalación

1. Ve a [Releases](https://github.com/pablo96sancho/CleanBRUH/releases/latest) y descarga únicamente `CleanBRUH-Installer.dmg`.
2. Abre el DMG y arrastra `CleanBRUH.app` a `Applications`.
3. Abre la app y concede el permiso de **Accesibilidad** cuando macOS lo solicite.

> No descargues el ZIP de la pestaña **Code**: contiene el código fuente. El DMG de la release es el instalador de la aplicación.

## Características

- Acceso rápido desde la barra de menú.
- Bloqueo de teclado, ratón y trackpad.
- Desbloqueo manteniendo pulsada la barra espaciadora.
- App nativa y ligera para macOS.

## Requisitos

- macOS 13 o posterior.
- Permiso de Accesibilidad: **Ajustes del Sistema → Privacidad y seguridad → Accesibilidad → CleanBRUH**.

## Desarrollo

```bash
bash create_dmg.sh
```

El comando genera `CleanBRUH-Installer.dmg` localmente. Ese archivo no se versiona: cada release de GitHub publica el DMG como descarga independiente.
