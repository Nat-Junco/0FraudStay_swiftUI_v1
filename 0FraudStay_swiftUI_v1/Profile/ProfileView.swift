//
//  ProfileView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import SwiftUI

struct ProfileView: View {
    
    let primaryColor = Color("BrandPrimaryColor")
    let cardbackColor = Color(.white)
    let backgroundColor = Color("FondoApp")
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("OFRAUD STAY")
                                .font(.caption)
                                .bold()
                                .foregroundColor(primaryColor)
                                .tracking(1)
                            Text("Mi perfil")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                        }
                        Spacer()
                        Image("appLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                            .padding(10)
                            .cornerRadius(12)
                    }
                    .padding(.top, 10)
                    
                    // Tarjeta de Usuario
                    NavigationLink(destination: EditProfileView()) {
                        HStack(spacing: 16) {
                            ZStack(alignment: .bottomTrailing) {
                                // DATOS DINÁMICOS / BASE DE DATOS:
                                Image(systemName: "person.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(primaryColor)
                                    .frame(width: 60, height: 60)
                                    .background(primaryColor.opacity(0.15))
                                    .cornerRadius(16)
                                
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(primaryColor)
                                    .background(Color.white.clipShape(Circle()))
                                    .offset(x: 4, y: 4)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                // Nombre obtenido de la BD
                                Text("Nombre del usuario")
                                    .font(.system(size: 20, weight: .bold, design: .serif))
                                    .foregroundColor(.primary)
                                
                                // Correo obtenido de la BD
                                Text("ejemplo@correo.com")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        .padding()
                        .background(cardbackColor)
                        .cornerRadius(18)
                    }
                    
                    // Estadísticas
                    HStack(spacing: 12) {
                        ProfileStatBox(icon: "doc.text", value: "2", label: "Reportes", backgroundColor: cardbackColor)
                        ProfileStatBox(icon: "triangle.fill", value: "1", label: "Reportes validados", backgroundColor: cardbackColor)
                        ProfileStatBox(icon: "shield.fill", value: "59", label: "Usuarios Alertados", backgroundColor: cardbackColor)
                    }

                    // Menú
                    VStack(spacing: 0) {
                        NavigationLink(destination: PrivacyView()) {
                            ProfileMenuItem(icon: "lock.fill", iconColor: .gray, title: "Privacidad y seguridad")
                        }
                        Divider()
                        
                        NavigationLink(destination: MyReportsView()) {
                            ProfileMenuItem(icon: "doc.text.fill", iconColor: .gray, title: "Todos mis reportes")
                        }
                        Divider()
                        
                        NavigationLink(destination: GuidesView()) {
                            ProfileMenuItem(icon: "diamond.fill", iconColor: .black, title: "Guías y consejos")
                        }
                        Divider()
                        
                        NavigationLink(destination: SupportView()) {
                            ProfileMenuItem(icon: "questionmark", iconColor: primaryColor, title: "Ayuda y soporte")
                        }
                    }
                    .background(cardbackColor)
                    .cornerRadius(18)
                    
                    Button(action: {
                        // FUNCIONALIDAD PENDIENTE
                    }) {
                        Text("Cerrar sesión")
                            .font(.headline)
                            .foregroundColor(primaryColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor.opacity(0.12))
                            .cornerRadius(16)
                    }
                    
                    Spacer() // Mantiene todo el contenido fijo arriba
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
    }
}

struct ProfileStatBox: View {
    let icon: String
    let value: String
    let label: String
    var backgroundColor: Color = Color(.systemGray6)
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.black)
            Text(value)
                .font(.system(size: 18, weight: .bold))
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(backgroundColor)
        .cornerRadius(16)
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let iconColor: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(iconColor)
                .frame(width: 24)
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#Preview {
    ProfileView()
}

