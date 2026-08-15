# CleanBRUH

Una app de menú para macOS que bloquea temporalmente teclado, trackpad y ratón para que puedas limpiar el equipo sin que se produzcan pulsaciones o clics accidentales.

<p align="center">
  <img src="cover.jpg" alt="CleanBRUH" width="900" />
</p>

## Descarga

- Descarga el instalador: [CleanBRUH-Installer.dmg](CleanBRUH-Installer.dmg)

## ¿Para qué sirve?

CleanBRUH está pensado para esos momentos en los que necesitas limpiar tu teclado, tu mesa de trabajo o la pantalla sin que el sistema registre pulsaciones o movimientos por accidente.

Mientras está activo, la app crea una superposición a pantalla completa y bloquea la entrada del sistema para que puedas trabajar sin interrupciones.

## Requisitos

- macOS 13 o superior
- Permisos de Accesibilidad

## Cómo usarla

1. Abre la app desde la barra de menú.
2. Pulsa en "Iniciar Limpieza".
3. La app bloqueará teclado, ratón y trackpad.
4. Para salir del modo limpieza, mantén pulsada la barra espaciadora durante 3 segundos.

## Permisos de Accesibilidad

CleanBRUH usa un `Event Tap` de CoreGraphics para interceptar la entrada del sistema, así que macOS necesita concederte permisos de Accesibilidad.

Cuando falten permisos, la app abre directamente la ventana correspondiente en Ajustes del Sistema para que puedas activarlos rápidamente.

## Compilar localmente

```bash
chmod +x build_and_run.sh scripts/bundle_app.sh
./build_and_run.sh
```

## Generar el instalador DMG

```bash
chmod +x create_dmg.sh scripts/bundle_app.sh
./create_dmg.sh
```

Esto genera una versión release con el bundle `.app` y el archivo `CleanBRUH-Installer.dmg` listo para compartir.

## Estructura del proyecto

- `Sources/CleanBRUH/Core/InputBlocker.swift` — lógica del bloqueo, permisos y desbloqueo.
- `Sources/CleanBRUH/UI/MenuBarManager.swift` — menú de la barra de estado.
- `Sources/CleanBRUH/UI/OverlayWindowController.swift` — ventana de bloqueo por pantalla.
- `Sources/CleanBRUH/UI/LockOverlayView.swift` — vista de la sobreimpresión de limpieza.

## Nota importante

CleanBRUH intercepta eventos del sistema durante el modo de limpieza. Eso requiere conceder permisos de Accesibilidad y revisar siempre el código antes de usarlo en entornos donde se quiera instalar binarios no firmados o compilados por terceros.

## Autor

Pablo Sancho
