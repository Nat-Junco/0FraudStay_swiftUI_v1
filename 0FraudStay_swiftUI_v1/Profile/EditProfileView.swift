import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var perfil: PerfilViewModel
    @Binding var alertasHabilitadas: Bool
    
    @State private var nombre: String = ""
    @State private var correo: String = ""
    @State private var guardando = false
    @State private var mostrarAlertaError = false
    
    private let rojoPrimary = Color("BrandPrimaryColor")
    private let fondoApp = Color("FondoApp")
    private let tarjeta = Color.white
    
    var body: some View {
        ZStack {
            fondoApp
                .ignoresSafeArea()
            
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
                                    Circle().stroke(tarjeta, lineWidth: 2)
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
                        }
                        .padding(16)
                        .background(tarjeta)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    // MARK: - Preferencias de Cuenta
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
                                
                                Toggle("", isOn: $alertasHabilitadas)
                                    .labelsHidden()
                                    .tint(rojoPrimary)
                            }
                        }
                        .padding(16)
                        .background(tarjeta)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    // MARK: - Botón Guardar Cambios
                    Button(action: {
                        Task {
                            guardando = true
                            let exito = await perfil.guardar(nombre: nombre, correo: correo)
                            guardando = false
                            
                            if exito {
                                dismiss()
                            } else {
                                mostrarAlertaError = true
                            }
                        }
                    }) {
                        Text(guardando ? "Guardando..." : "Guardar Cambios")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(rojoPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, 16)
                    .disabled(guardando)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Editar Perfil")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            nombre = perfil.nombre
            correo = perfil.correo
            perfil.errorMessage = nil
        }
        .alert("No se pudo actualizar", isPresented: $mostrarAlertaError) {
            Button("Aceptar", role: .cancel) { 
             // Vacío a propósito: el rol .cancel cierra la alerta automáticamente
            }
        } message: {
            Text(perfil.errorMessage ?? "Revisa tus datos e intenta de nuevo.")
        }
    }
    
    // MARK: - Campo Visual Editable
    @ViewBuilder
    private func campoVisual(
        titulo: String,
        icono: String,
        texto: Binding<String>,
        teclado: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                Image(systemName: icono)
                    .foregroundStyle(rojoPrimary)
                    .frame(width: 20)
                
                TextField(titulo, text: texto)
                    .font(.system(size: 15))
                    .foregroundStyle(.primary)
                    .keyboardType(teclado)
                    .autocorrectionDisabled()
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView(
            perfil: PerfilViewModel(),
            alertasHabilitadas: .constant(true)
        )
    }
}
