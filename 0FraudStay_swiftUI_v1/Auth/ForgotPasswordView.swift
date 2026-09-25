//
//  ForgotPasswordView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 25/09/26.
//

import SwiftUI

struct ForgotPasswordView: View {

    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                // Acción al presionar el botón
            }) {
                Text("Recuperar contraseña")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

#Preview {
    ForgotPasswordView()    
}
