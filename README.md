# 🧹 CleanBRUH

> Limpia tu Mac sin activar teclas, clics ni gestos por accidente.

CleanBRUH es una aplicación ligera para la barra de menú de macOS que bloquea temporalmente el teclado, el ratón y el trackpad mientras limpias, reparas o trabajas sobre el equipo.

[![Download DMG](https://img.shields.io/github/v/release/pablo96sancho/CleanBRUH?label=Descargar%20DMG&color=007AFF&logo=apple)](https://github.com/pablo96sancho/CleanBRUH/releases/latest)

---

## 🚀 Características

- 🧹 Activación rápida desde la barra de menú
- ⌨️ Bloquea teclado, ratón y trackpad al instante
- ⏱️ Desbloqueo manteniendo pulsada la barra espaciadora durante 3 segundos
- 💻 Diseño nativo, ligero y centrado en macOS
- 🔒 Bloqueo de atajos y controles hardware mientras está activo

---

## 📸 Vista previa

![CleanBRUH Preview](cover.jpg)

---

## 📦 Instalación

1. Descarga la última versión desde [GitHub Releases](https://github.com/pablo96sancho/CleanBRUH/releases/latest).
2. Abre el archivo `CleanBRUH-Installer.dmg`.
3. Arrastra **CleanBRUH.app** a la carpeta **Aplicaciones**.
4. Ejecuta la app desde la barra de menú.

---

## 🔒 Permisos

CleanBRUH usa un `event tap` de macOS para bloquear la entrada del sistema, por lo que requiere permiso de **Accesibilidad**.

Puedes concederlo en:

**Ajustes del Sistema → Privacidad y seguridad → Accesibilidad**

---

## 🛠️ Desarrollo

### Requisitos

- macOS 13 o superior
- Xcode 15+ o Xcode Command Line Tools (`xcode-select --install`)
- Swift 5.9+

### Compilar y ejecutar

```bash
chmod +x build_and_run.sh
./build_and_run.sh
```

Para generar el instalador:

```bash
./create_dmg.sh
```

Esto crea `CleanBRUH-Installer.dmg` localmente. En GitHub, el instalador se publica como archivo adjunto de cada Release.
