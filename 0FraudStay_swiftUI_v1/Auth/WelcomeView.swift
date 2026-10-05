//
//  WelcomeView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                Image(.appLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                
                Text("0Fraud Stay")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Reportes comunitarios de fraudes en hospedajes vacacionales")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Spacer()
                
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.red)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        (Text("+1,600 reportes ")
                            .bold().foregroundColor(.red)).font(.system(size: 13))
                        (Text("registrados de ene–mar 2026 según el Consejo Ciudadano para la Seguridad de CDMX."))
                            .font(.system(size: 13))
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)
                .padding(.horizontal, 24)
                Spacer()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
