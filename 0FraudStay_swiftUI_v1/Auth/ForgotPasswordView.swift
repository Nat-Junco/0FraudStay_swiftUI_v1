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
    var body: some View {
        
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordView()
    }
}
