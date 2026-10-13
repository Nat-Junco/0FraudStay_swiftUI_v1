//
//  WelcomeView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import SwiftUI

struct WelcomeView: View {
    private let fondo = Color("FondoApp")
    
    var body: some View {
        ZStack {
            fondo
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 170)
                
                // Tarjeta centrada
                VStack(spacing: 20) {
                    Image(.appLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("0Fraud Stay")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity) // Garantiza el centrado del texto
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 24)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
