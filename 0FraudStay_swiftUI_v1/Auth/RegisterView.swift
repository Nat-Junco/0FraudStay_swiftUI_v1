//
//  RegisterView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import SwiftUI

struct RegisterView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                // Acción al presionar el botón
            }) {
                Text("Registrarme")
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
    RegisterView()
}
