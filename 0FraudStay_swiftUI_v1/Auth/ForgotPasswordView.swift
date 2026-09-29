//
//  ForgotPasswordView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 25/09/26.
//

import SwiftUI

//Creación de pantalla con elementos
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
        Text("Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu cuenta.")
        .font(.subheadline)
        .foregroundColor(.gray)}.padding(.top, 16)
            
VStack(alignment: .leading, spacing: 6) {
        Text("CORREO ELECTRÓNICO")
        .font(.caption)
        .bold()
        .foregroundColor(.gray)
    
TextField("Ingresa tu correo electróncico", text: $email)
        .keyboardType(.emailAddress)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .foregroundColor(.black)
        .padding()
        .background(Color(.white))
        .cornerRadius(12)}
            
Spacer()
    Button(action: {
// Botón paara enviar correo
}) {
    Text("Enviar código de recuperación")
    .font(.headline)
    .foregroundColor(.white)
    .frame(maxWidth: .infinity)
    .padding()
    .background(primaryColor)
    .cornerRadius(12)}
    .padding(.bottom, 10)}
    .padding(.horizontal, 24)
                }
    .tint(primaryColor)
                }
                }

#Preview {
    ForgotPasswordView()    
}
