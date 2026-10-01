//
//  EditProfileView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by Marbella Barba De Los Santos on 29/09/26.
//

import SwiftUI

struct EditProfileView: View {
    
    @State private var alertasHabilitadas: Bool = true
    
    // Colores obtenidos directamente de los Assets
    private let rojoPrimary = Color("BrandPrimaryColor")
    private let verdeVerificate = Color("VerificateColor")
    private let fondo = Color("AppFondo")
    private let fondoTarjeta = Color(.white)
    private let textoPrincipal = Color(.label)
    private let textoGris = Color(.secondaryLabel)
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
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
                                    Circle().stroke(fondoTarjeta, lineWidth: 2)
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
                            .foregroundStyle(textoGris)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 14) {
                            campoVisual(
                                titulo: "Nombre completo",
                                icono: "person.fill",
                                valor: "Marbella Barba"
                            )
                            
                            Divider()
                            
                            campoVisual(
                                titulo: "Correo electrónico",
                                icono: "envelope.fill",
                                valor: "marbella@ejemplo.com"
                            )
                            
                            Divider()
                            
                            campoVisual(
                                titulo: "Contraseña",
                                icono: "phone.fill",
                                valor: "+52 55 1234 5678"
                            )
                            
                        }
                        .padding(16)
                        .background(fondoTarjeta)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    // MARK: - Preferencias de Cuenta
                    VStack(alignment: .leading, spacing: 16) {
                        Text("PREFERENCIAS DE CUENTA")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.secondary) // Adaptativo para subtítulos
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 14) {
                            HStack(spacing: 12) {
                                Image(systemName: "bell.fill")
                                    .foregroundStyle(rojoPrimary)
                                    .frame(width: 24)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Alertas de fraudes")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(.primary) // Negro en Modo Claro / Blanco en Modo Oscuro
                                    
                                    Text("Recibir notificaciones sobre reportes en tu zona")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.secondary) // Gris adaptativo
                                }
                                
                                Spacer()
                                
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
                    Text("Guardar Cambios")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(rojoPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.top, 12)
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .background(fondo.ignoresSafeArea())
            .navigationTitle("Editar Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Cancelar")
                        .font(.system(size: 16))
                        .foregroundStyle(textoGris)
                }
            }
        }
    }

    // Subview puramente estática para maqueta de campos
    @ViewBuilder
    private func campoVisual(
        titulo: String,
        icono: String,
        valor: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(textoGris)
            
            HStack(spacing: 12) {
                Image(systemName: icono)
                    .foregroundStyle(rojoPrimary)
                    .frame(width: 20)
                
                TextField(titulo, text: .constant(valor))
                    .font(.system(size: 15))
                    .foregroundStyle(textoPrincipal)
            }
        }
    }
    }

#Preview {
    EditProfileView()
}
