//
//  RegisterView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import SwiftUI
struct RegisterView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    private let primaryColor = Color("BrandPrimaryColor")
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 18) {
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Crea tu cuenta")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                    Text("La comunidad necesita tu voz para detener fraudes")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 16)
                // Name
                VStack(alignment: .leading, spacing: 14) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("NOMBRE COMPLETO")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        TextField("Escribe tu nombre completo", text: $fullName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CORREO ELECTRÓNICO")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        TextField("Escribe tu correo", text: $email)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CONTRASEÑA")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        SecureField("Mín. 8 caracteres", text: $password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    // Confirm Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CONFIRMAR CONTRASEÑA")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        SecureField("Repite tu contraseña", text: $confirmPassword)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                Spacer()
                Button(action: {
                    // Acción al presionar el botón
                }) {
                    NavigationLink {
                        TermsView()
                    } label: {
                        Text("Registrarme")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 10)            }
                .padding(.horizontal, 24)
            }
            .tint(primaryColor)
        }
    }}
#Preview {
    NavigationStack {
        RegisterView()
    }
}

