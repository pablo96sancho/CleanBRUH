import SwiftUI

/// Vista de la superposición de "Modo Limpieza": pantalla completa, oscura
/// y con la barra de progreso del gesto de desbloqueo.
struct LockOverlayView: View {
    @ObservedObject var inputBlocker: InputBlocker

    var body: some View {
        ZStack {
            Color.black.opacity(0.97)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Text("🧹")
                    .font(.system(size: 72))

                Text("CleanBRUH — Modo Limpieza Activo")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("El teclado, el trackpad y el ratón están bloqueados.\nLimpia tu equipo con total tranquilidad.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)

                VStack(spacing: 14) {
                    Text("Mantén pulsada la barra ESPACIADORA durante 3 segundos para desbloquear")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)

                    ProgressBar(progress: inputBlocker.holdProgress)
                        .frame(width: 280, height: 10)
                }
                .padding(.top, 20)
            }
            .padding(48)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
        }
    }
}

/// Barra de progreso minimalista para el gesto de mantener pulsado.
private struct ProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.12))

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.green, .mint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * progress)
                    .animation(.linear(duration: 0.05), value: progress)
            }
        }
        .clipShape(Capsule())
    }
}
