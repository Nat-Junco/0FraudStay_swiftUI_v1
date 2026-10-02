//
//  SupportView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by Marbella Barba De Los Santos on 29/09/26.
//

import SwiftUI
struct SupportView: View {
    let primaryColor = Color("BrandPrimaryColor")
    let backgroundColor = Color("FondoApp")
    let cardColor = Color.white
    
    @State private var expandedFAQIndex: Int? = nil
    
    let faqs: [(pregunta: String, respuesta: String)] = [
        ("¿Cómo reporto un fraude?", "Ve a la pestaña principal de la aplicación, presiona el botón '+' o 'Crear reporte' y completa los campos con la información relevante y evidencias que tengas."),
        ("¿Mis datos personales son públicos?", "No, tu información personal está protegida. Los reportes publicados únicamente muestran los detalles de la propiedad o usuario reportado."),
        ("¿Puedo editar o eliminar mi reporte?", "Sí, puedes ver y gestionar todos tus reportes desde tu perfil en la sección 'Todos mis reportes' antes de que algún administrador los apruebe."),
        ("¿Cómo sé si una propiedad es legítima?", "Te recomendamos revisar la sección de guías donde encontrarás algunos consejos para evitar caer en algún fraude."),
        ("¿Cuánto tiempo tarda en verificarse mi denuncia?", "Nuestro equipo revisa las evidencias ingresadas en un lapso promedio de 24 a 48 horas hábiles.")
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("0FRAUD STAY")
                        .font(.caption)
                        .bold()
                        .foregroundColor(primaryColor)
                        .tracking(1)
                    
                    Text("Ayuda y soporte")
                        .font(.system(size: 26, weight: .bold, design: .serif))
                        .foregroundColor(.primary)
                }
                .padding(.top, 10)
        
                Text("Preguntas frecuentes")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                VStack(spacing: 12) {
                    ForEach(0..<faqs.count, id: \.self) { index in
                        FAQCard(
                            pregunta: faqs[index].pregunta,
                            respuesta: faqs[index].respuesta,
                            isExpanded: expandedFAQIndex == index,
                            cardColor: cardColor,
                            primaryColor: primaryColor,
                            onTap: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    if expandedFAQIndex == index {
                                        expandedFAQIndex = nil
                                    } else {
                                        expandedFAQIndex = index
                                    }
                                }
                            }
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("¿Necesitas más ayuda?")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Contáctanos por correo.")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Text("soporte@Ofraudstay.mx")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(primaryColor)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding(20)
                .background(primaryColor.opacity(0.08))
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(primaryColor.opacity(0.15), lineWidth: 1)
                )
                .padding(.top, 12)
                
                Spacer(minLength: 30)
            }
            .padding(.horizontal, 20)
        }
        .background(backgroundColor.ignoresSafeArea())
    }
}
struct FAQCard: View {
    let pregunta: String
    let respuesta: String
    let isExpanded: Bool
    let cardColor: Color
    let primaryColor: Color
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack {
                    Text(pregunta)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 18)
            }
            
            if isExpanded {
                VStack(alignment: .leading) {
                    Divider()
                        .padding(.horizontal, 18)
                    
                    Text(respuesta)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(cardColor)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
    }
}
#Preview {
    NavigationStack {
        SupportView()
    }
}

