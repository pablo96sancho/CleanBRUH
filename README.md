<div align="center">

<img src="Sources/CleanBRUH/Resources/AppIcon.iconset/icon_256x256@2x.png" width="128" alt="Icono de CleanBRUH" />

# CleanBRUH

**Limpia tu Mac sin activar teclas, clics ni gestos por accidente.**

[![Descargar para macOS](https://img.shields.io/badge/Descargar_para_macOS-0071E3?style=for-the-badge&logo=apple&logoColor=white)](https://github.com/pablo96sancho/CleanBRUH/releases/latest/download/CleanBRUH-Installer.dmg)

![Versión](https://img.shields.io/github/v/release/pablo96sancho/CleanBRUH?style=flat-square&label=versión&color=000000)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-000000?style=flat-square&logo=apple&logoColor=white)
![Apple Silicon](https://img.shields.io/badge/Apple_Silicon-M1%2B-000000?style=flat-square)
![Licencia MIT](https://img.shields.io/badge/licencia-MIT-000000?style=flat-square)

[🇬🇧 English version](./README.en.md)

</div>

<br />

<p align="center">
  <img src="cover.jpg" width="720" alt="CleanBRUH con el modo limpieza activo en la pantalla de un MacBook" />
</p>

CleanBRUH es una app de la barra de menú que bloquea temporalmente el teclado, el ratón
y el trackpad para que puedas limpiar el Mac sin escribir nada, abrir apps ni cambiar el
volumen sin querer.

## Características

- 🧹 Se activa con un clic desde la barra de menú.
- ⌨️ Bloquea teclado, ratón y trackpad al instante, incluidos los atajos y las teclas de función.
- ⏱️ Para desbloquear, mantén pulsada la **barra espaciadora 3 segundos**.
- 💻 Nativa y ligera: hecha en Swift, sin dependencias.

## Instalación

1. [Descarga el instalador](https://github.com/pablo96sancho/CleanBRUH/releases/latest/download/CleanBRUH-Installer.dmg).
2. Ábrelo y arrastra **CleanBRUH.app** a **Aplicaciones**.
3. Ábrela. Aparecerá en la barra de menú.

### Primera apertura

La app no está firmada con una cuenta de Apple Developer, así que la primera vez macOS
la bloquea con un aviso. Para abrirla:

1. Intenta abrir CleanBRUH y cierra el aviso (sin moverla a la Papelera).
2. Ve a **Ajustes del Sistema → Privacidad y seguridad**.
3. En la sección **Seguridad**, pulsa **Abrir igualmente** junto al mensaje sobre CleanBRUH.
4. Confirma con tu contraseña o Touch ID. Solo hace falta la primera vez.

<details>
<summary>Alternativa desde la Terminal</summary>

```bash
xattr -dr com.apple.quarantine /Applications/CleanBRUH.app
```

</details>

### Permisos

CleanBRUH usa un `event tap` de macOS para bloquear la entrada, así que necesita permiso
de **Accesibilidad**: *Ajustes del Sistema → Privacidad y seguridad → Accesibilidad*.

## Desarrollo

Requisitos: macOS 13 o superior, Xcode 15+ (o las Command Line Tools) y Swift 5.9+.

```bash
./build_and_run.sh   # compila y abre la app
./create_dmg.sh      # genera CleanBRUH-Installer.dmg
```

Cada Release de GitHub publica el DMG automáticamente con GitHub Actions.

## Licencia

[MIT](LICENSE) © Pablo Sancho
