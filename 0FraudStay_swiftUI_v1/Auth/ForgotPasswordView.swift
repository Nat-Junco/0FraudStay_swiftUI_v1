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
        let primaryColor = Color("BrandPrimaryColor")
        var body: some View {
                ZStack {
                        Color.white
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
                                            .foregroundColor(.gray)
                                    }}}}}

#Preview {
    ForgotPasswordView()    
}
