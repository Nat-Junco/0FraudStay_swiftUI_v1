//
//  ForgotPasswordView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 25/09/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    private let primaryColor = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")
    
    var body: some View {
        ZStack {
            fondo
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("OFRAUD STAY")
                        .font(.caption)
                        .bold()
                        .foregroundColor(primaryColor)
                        .tracking(1)
                    Text("Recuperar contraseña")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                    Text("Ingresa tu correo electrónico y te enviaremos un código para restablecer tu contraseña.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 16)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("CORREO ELECTRÓNICO")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.gray)
                    TextField("Ingresa tu correo electrónico", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(12)
                }
                
                Spacer()
                
                NavigationLink(destination: EnterTokenView()) {
                    Text("Enviar código")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryColor)
                        .cornerRadius(12)
                }
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 24)
        }
        .tint(primaryColor)
    }
}

struct EnterTokenView: View {
    @State private var token = ""
    private let primaryColor = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")
    
    var body: some View {
        ZStack {
            fondo
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("OFRAUD STAY")
                        .font(.caption)
                        .bold()
                        .foregroundColor(primaryColor)
                        .tracking(1)
                    Text("Ingresar token")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                    Text("Ingresa el código de verificación que hemos enviado a tu correo.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 16)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("TOKEN DE VERIFICACIÓN")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.gray)
                    TextField("Ingresa el token", text: $token)
                        .keyboardType(.numberPad)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(12)
                }
                
                Button(action: {
                    // Lógica futura para reenviar el token
                }) {
                    Text("¿No te llegó el token? Volver a enviar")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(primaryColor)
                }
                
                Spacer()
                
                NavigationLink(destination: ResetPasswordView()) {
                    Text("Verificar token")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryColor)
                        .cornerRadius(12)
                }
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 24)
        }
    }
}

struct ResetPasswordView: View {
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    private let primaryColor = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")
    
    var body: some View {
        ZStack {
            fondo
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("OFRAUD STAY")
                        .font(.caption)
                        .bold()
                        .foregroundColor(primaryColor)
                        .tracking(1)
                    Text("Restablecer contraseña")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                    Text("Crea una nueva contraseña para tu cuenta.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 16)
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("NUEVA CONTRASEÑA")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        SecureField("Ingresa tu nueva contraseña", text: $newPassword)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CONFIRMAR CONTRASEÑA")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        SecureField("Confirma tu nueva contraseña", text: $confirmPassword)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(12)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // Lógica futura para guardar la contraseña y volver al Login
                }) {
                    Text("Confirmar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryColor)
                        .cornerRadius(12)
                }
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 24)
        }
    }
}
#Preview {
    NavigationStack {
        ForgotPasswordView()
    }
}
