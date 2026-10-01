import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Bindings para sincronizar con la pantalla principal de Perfil
    @Binding var nombre: String
    @Binding var correo: String
    @Binding var alertasHabilitadas: Bool
    
    // Variable local para la contraseña
    @State private var contrasena: String = ""
    
    private let rojoPrimary = Color("BrandPrimaryColor")
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // MARK: - Foto de Perfil
                    VStack(spacing: 12) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(rojoPrimary.opacity(0.8))
                                .background(Circle().fill(rojoPrimary.opacity(0.1)))
                                .clipShape(Circle())
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(rojoPrimary)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color(.secondarySystemGroupedBackground), lineWidth: 2)
                                )
                        }
                        
                        Text("Cambiar foto de perfil")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(rojoPrimary)
                    }
                    .padding(.top, 12)
                    
                    // MARK: - Formulario de Información Personal
                    VStack(alignment: .leading, spacing: 16) {
                        Text("INFORMACIÓN PERSONAL")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 14) {
                            campoVisual(
                                titulo: "Nombre completo",
                                icono: "person.fill",
                                texto: $nombre
                            )
                            
                            Divider()
                            
                            campoVisual(
                                titulo: "Correo electrónico",
                                icono: "envelope.fill",
                                texto: $correo,
                                teclado: .emailAddress
                            )
                            
                            Divider()
                            
                            campoVisual(
                                titulo: "Contraseña",
                                icono: "lock.fill",
                                texto: $contrasena,
                                esSeguro: true
                            )
                        }
                        .padding(16)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    // MARK: - Preferencias de Cuenta (Notificaciones)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("PREFERENCIAS DE CUENTA")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 14) {
                            HStack(spacing: 12) {
                                Image(systemName: "bell.fill")
                                    .foregroundStyle(rojoPrimary)
                                    .frame(width: 24)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Alertas de fraudes")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(.primary)
                                    Text("Recibir notificaciones sobre reportes en tu zona")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                // El estado del toggle ahora se guarda directamente
                                Toggle("", isOn: $alertasHabilitadas)
                                    .labelsHidden()
                                    .tint(rojoPrimary)
                            }
                        }
                        .padding(16)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    // MARK: - Botón Guardar Cambios
                    Button(action: {
                        dismiss() // Cierra la vista manteniendo el estado actualizado del Toggle y TextFields
                    }) {
                        Text("Guardar Cambios")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(rojoPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, 12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Editar Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    // MARK: - Campo Visual Editable
    @ViewBuilder
    private func campoVisual(
        titulo: String,
        icono: String,
        texto: Binding<String>,
        teclado: UIKeyboardType = .default,
        esSeguro: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                Image(systemName: icono)
                    .foregroundStyle(rojoPrimary)
                    .frame(width: 20)
                
                if esSeguro {
                    SecureField("Ingresa contraseña", text: texto)
                        .font(.system(size: 15))
                        .foregroundStyle(.primary)
                } else {
                    TextField(titulo, text: texto)
                        .font(.system(size: 15))
                        .foregroundStyle(.primary)
                        .keyboardType(teclado)
                        .autocorrectionDisabled()
                }
            }
        }
    }
}

#Preview {
    EditProfileView(
        nombre: .constant("Marbella Barba"),
        correo: .constant("marbella@ejemplo.com"),
        alertasHabilitadas: .constant(true)
    )
}
