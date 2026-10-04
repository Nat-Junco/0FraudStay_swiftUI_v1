import SwiftUI

struct TermsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isAccepted: Bool
    var onAccept: (() -> Void)? = nil
    @State private var localIsAccepted: Bool = false
    
    private let rojoPrimary = Color("BrandPrimaryColor")
    private var acceptedBinding: Binding<Bool> {
            Binding(
                get: { $isAccepted.wrappedValue },
                set: { isAccepted = $0 }
            )
        }
    init(isAccepted: Binding<Bool> = .constant(false), onAccept: (() -> Void)? = nil) {
            self._isAccepted = isAccepted
            self.onAccept = onAccept
        }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("0FRAUD STAY")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(rojoPrimary)
                            .tracking(1)
                        
                        Text("Términos y Condiciones")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundStyle(.primary)
                        
                        Text("Última actualización: Octubre 2026")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 8)
                    VStack(alignment: .leading, spacing: 18) {
                        
                        seccionTexto(
                            titulo: "1. Aceptación de los Términos",
                            contenido: "Al descargar, acceder o utilizar la aplicación OFRAUD STAY, aceptas quedar vinculado por los presentes Términos y Condiciones. Si no estás de acuerdo con alguno de los puntos, te pedimos abstenerte de utilizar la plataforma."
                        )
                        
                        Divider()
                        
                        seccionTexto(
                            titulo: "2. Uso de la Plataforma y Registro",
                            contenido: "OFRAUD STAY es una herramienta comunitaria orientada a la prevención e identificación de fraudes en rentas vacacionales. Para publicar reportes o interactuar con la plataforma, debes registrarte proporcionando información verídica y mantener la confidencialidad de tus credenciales de acceso."
                        )
                        
                        Divider()
                        
                        seccionTexto(
                            titulo: "3. Publicación de Reportes y Contenido",
                            contenido: "Al emitir una alerta o denuncia, declaras que los hechos expuestos son reales y que actúas de buena fe. Queda estrictamente prohibido:\n• Publicar información falsa, engañosa o difamatoria.\n• Compartir datos personales sensibles de terceros no involucrados.\n• Utilizar lenguaje de odio, ofensivo o promocionar servicios no autorizados."
                        )
                        
                        Divider()
                        
                        seccionTexto(
                            titulo: "4. Moderación y Responsabilidad del Contenido",
                            contenido: "OFRAUD STAY actúa como un canal de colaboración ciudadana. Aunque implementamos filtros de moderación, no nos hacemos responsables por la precisión de la información compartida directamente por los usuarios ni por transacciones externas celebradas entre terceros."
                        )
                        
                        Divider()
                        
                        seccionTexto(
                            titulo: "5. Cancelación y Modificaciones",
                            contenido: "Nos reservamos el derecho de suspender o eliminar cuentas que infrinjan estas normas, así como de actualizar estos Términos y Condiciones en cualquier momento para adaptarlos a mejoras continuas en la plataforma o cambios legislativos."
                        )
                    }
                    .padding(20)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    VStack(spacing: 16) {
                                            
                                            // Checkbox
                                            Button {
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    isAccepted.toggle()
                                                }
                                            } label: {
                                                HStack(alignment: .top, spacing: 12) {
                                                    Image(systemName: isAccepted ? "checkmark.square.fill" : "square")
                                                        .font(.system(size: 20, weight: .semibold))
                                                        .foregroundStyle(isAccepted ? rojoPrimary : .secondary)
                                                    
                                                    Text("He leído y acepto expresamente los Términos y Condiciones de Uso de 0FRAUD STAY.")
                                                        .font(.subheadline)
                                                        .foregroundStyle(.primary)
                                                        .multilineTextAlignment(.leading)
                                                }
                                            }
                                            .buttonStyle(.plain)
                                            
                                            Button {
                                                onAccept?()
                                                dismiss()
                                            } label: {
                                                Text("Continuar")
                                                    .font(.headline)
                                                    .foregroundStyle(.white)
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 50)
                                                    .background(isAccepted ? rojoPrimary : Color.gray.opacity(0.4))
                                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                            }
                                            .disabled(!isAccepted)
                                        }
                                        .padding(20)
                                        .background(Color(.secondarySystemGroupedBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    HStack(spacing: 8) {
                                            Image(systemName: "doc.badge.checkmark")
                                                .foregroundStyle(rojoPrimary)
                                                .font(.system(size: 16))
                                            
                                            Text("Al usar la aplicación aceptas operar bajo principios de buena fe y respeto comunitario.")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        .padding(.horizontal, 4)
                                        .padding(.bottom, 20)
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .background(Color(.systemGroupedBackground).ignoresSafeArea())
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .topBarLeading) {
                                        Button {
                                            dismiss()
                                        } label: {
                                            HStack(spacing: 4) {
                                                Image(systemName: "chevron.left")
                                                Text("Atrás")
                                            }
                                            .foregroundStyle(.primary)
                                        }
                                    }
                                }
                            }
                        }
    @ViewBuilder
    private func seccionTexto(titulo: String, contenido: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.primary)
            
            Text(contenido)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .lineSpacing(3)
        }
    }
}

#Preview {
    TermsView()
}
