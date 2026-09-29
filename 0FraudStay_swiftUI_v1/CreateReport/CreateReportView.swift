//
//  CreateReportView.swift
//  0FraudStay_swiftUI_v1
//



import SwiftUI

struct CreateReportView: View {
    @Environment(\.dismiss) var dismiss
    
    // Control de flujo por pasos
    @State private var pasoActual = 1
    
    // Datos del formulario
    @State private var titulo = ""
    @State private var plataforma = "Facebook Marketplace"
    @State private var precio = ""
    @State private var ubicacion = ""
    @State private var tipoFraude = "Propiedad fantasma"
    @State private var descripcion = ""
    @State private var contactoVendedor = ""
    @State private var enlaceAnuncio = ""
    @State private var evidenciaSubida = false
    
    // Paleta de colores unificada
    private let rojo = Color("BrandPrimaryColor")
    private let verde = Color("VerificateColor")
    private let fondo = Color(red: 0.95, green: 0.95, blue: 0.97)
    private let borde = Color(red: 0.90, green: 0.90, blue: 0.92)
    private let textoPrincipal = Color(red: 0.11, green: 0.11, blue: 0.12)
    private let textoGris = Color(red: 0.56, green: 0.56, blue: 0.58)
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 1. HEADER FIJO CON LOGO Y NAVEGACIÓN
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("OFRAUD STAY")
                            .font(.system(size: 12, weight: .bold))
                            .kerning(1.2)
                            .foregroundStyle(rojo)
                        Text("Crear reporte")
                            .font(.system(size: 26, weight: .bold, design: .serif))
                            .foregroundStyle(textoPrincipal)
                    }
                    Spacer()
                    
                    Image("appLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                        .background(rojo.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(rojo.opacity(0.25), lineWidth: 1)
                        )
                }
                
                // Barra de progreso de 3 pasos
                HStack(spacing: 8) {
                    ForEach(1...3, id: \.self) { paso in
                        Rectangle()
                            .fill(paso <= pasoActual ? rojo : borde)
                            .frame(height: 4)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
            .background(Color.white)
        }
    }
}
            


#Preview {
    NavigationStack {
        CreateReportView()
    }
}

