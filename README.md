# 🧹 CleanBRUH

CleanBRUH es una utilidad nativa de macOS que bloquea temporalmente el
teclado, el trackpad y el ratón desde la barra de menú, para poder limpiar
el equipo físicamente sin pulsar teclas o hacer clics por accidente.

## Requisitos

- macOS 13 (Ventura) o superior
- Xcode Command Line Tools (`xcode-select --install`)

## Instalación y permisos de Accesibilidad

CleanBRUH usa un *Event Tap* de CoreGraphics para interceptar la entrada del
sistema, lo que requiere permiso de **Accesibilidad**:

1. Abre la app (o ejecuta `./build_and_run.sh`).
2. Ve al menú de la barra de estado → **"Comprobar Permisos de Accesibilidad"**.
3. macOS abrirá **Ajustes del Sistema → Privacidad y seguridad → Accesibilidad**.
4. Activa el interruptor junto a **CleanBRUH**.
5. Si el sistema también solicita permiso de **Monitorización de entrada**
   (Input Monitoring), concédelo igualmente en la misma sección de Ajustes.

> ⚠️ Al usar una firma *ad-hoc* durante el desarrollo, macOS puede pedirte
> que vuelvas a conceder el permiso tras cada recompilación (cambia el hash
> del binario). Para distribución final, firma con un Developer ID de Apple
> para que el permiso persista entre versiones.

## Uso

1. Haz clic en el icono ✨ de la barra de menú.
2. Selecciona **"Iniciar Limpieza"**. Aparecerá una superposición oscura en
   todas las pantallas conectadas y el teclado/trackpad/ratón dejarán de
   responder.
3. Para desbloquear, **mantén pulsada la barra ESPACIADORA durante 3
   segundos** (verás la barra de progreso). También puedes forzar la salida
   desde **"Salir"** en el menú si vuelves a tener control del ratón.

## Compilar y ejecutar en local

```bash
chmod +x build_and_run.sh scripts/bundle_app.sh
./build_and_run.sh
```

Esto compila con `swift build`, empaqueta el binario como
`.build/debug/CleanBRUH.app` y lo lanza.

## Crear el instalador `.dmg`

```bash
chmod +x create_dmg.sh scripts/bundle_app.sh
./create_dmg.sh
```

Esto compila en modo `release`, genera `.build/release/CleanBRUH.app` y
produce `CleanBRUH-Installer.dmg` en la raíz del proyecto, listo para
distribuir (con un enlace simbólico a `/Applications` incluido).

## Estructura del proyecto

- `Core/InputBlocker.swift` — Event Tap de CoreGraphics, permisos y lógica
  de desbloqueo por pulsación mantenida.
- `UI/LockOverlayView.swift` — Vista SwiftUI de la superposición.
- `UI/OverlayWindowController.swift` — Crea una `NSWindow` por pantalla.
- `UI/MenuBarManager.swift` — Icono y menú de la barra de estado.

## Aviso

CleanBRUH intercepta y descarta eventos de entrada a nivel de sistema
mientras el Modo Limpieza está activo. Al ser software de terceros con este
nivel de acceso, revisa el código antes de conceder permisos de
Accesibilidad, especialmente si distribuyes binarios compilados por otros.
