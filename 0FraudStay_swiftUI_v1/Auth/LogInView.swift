//
//  LogInView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import SwiftUI

struct LogInView: View {
    @State private var isLoggedIn = false
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        if isLoggedIn {
            StartView()
        } else {
            NavigationStack {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Text("Iniciar Sesión")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 12) {
                        TextField("Correo electrónico", text: $email).textFieldStyle(.roundedBorder)

                        SecureField("Contraseña", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal, 24)
                    
                    Button(action: {
                        withAnimation {
                            isLoggedIn = true
                        }
                    }) {
                        Text("Iniciar Sesión")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("¿Olvidaste tu contraseña?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                    Spacer()
                    
                    HStack {
                        Text("¿No tienes una cuenta?")
                            .foregroundColor(.secondary)
                        NavigationLink(destination: RegisterView()) {
                            
                            Text("Regístrate")
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    .font(.subheadline)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

#Preview {
    LogInView()
}
