import SwiftUI
struct AntiFraudGuideView: View {
    private let rojo = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")
    private let tarjeta = Color.white
    private let borde = Color("Border")

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                // MARK: 1. Título
                VStack(alignment: .leading, spacing: 8) {
                    Text("0FRAUD STAY")
                        .font(.system(size: 12, weight: .bold))
                        .kerning(1.2)
                        .foregroundStyle(rojo)
                    Text("Guía antifraude")
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundStyle(.primary)
                    Text("\(GuiasData.tips.count) tips concretos para detectar y evitar estafas en rentas vacacionales")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }
                // MARK: 2. Regla de oro
                HStack(alignment: .top, spacing: 12) {
                    Image(.lock)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 40)
                    Text("Regla de oro: si te presionan para pagar rápido o por fuera de la plataforma, detente.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(rojo.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(rojo.opacity(0.25), lineWidth: 1)
                )
                // MARK: 3. Lista de tips (datos fijos de GuiasData)
                ForEach(GuiasData.tips) { tip in
                    HStack(alignment: .top, spacing: 14) {
                        // Número del tip
                        Text("\(tip.id)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(rojo)
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(tip.titulo)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(tip.descripcion)
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(16)
                    .background(tarjeta)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(borde, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(fondo.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    NavigationStack {
        AntiFraudGuideView()
    }
}


