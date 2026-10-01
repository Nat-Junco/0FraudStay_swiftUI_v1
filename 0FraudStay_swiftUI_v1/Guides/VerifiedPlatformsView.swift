//
//  VerifiedPlatformsView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 30/09/26.
//

import SwiftUI

struct VerifiedPlatformsView: View {

    private let rojo = Color("BrandPrimaryColor")
    private let verde = Color("VerificateColor")
    private let fondo = Color("FondoApp")
    private let tarjeta = Color(.secondarySystemGroupedBackground)
    private let borde = Color(.systemGray5)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {

                // MARK: 1. Título
                VStack(alignment: .leading, spacing: 8) {
                    Text("GUÍAS")
                        .font(.system(size: 12, weight: .bold))
                        .kerning(1.2)
                        .foregroundStyle(rojo)
                    Text("Plataformas verificadas")
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundStyle(.primary)
                    Text("Sitios oficiales y seguros para reservar tu hospedaje")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }

                // MARK: 2. Aviso
                HStack(alignment: .top, spacing: 12) {
                    Text("🛡️")
                        .font(.system(size: 20))
                    Text("Revisa que la dirección coincida exactamente. Los estafadores usan sitios con nombres parecidos, como airbnb-reservas.com.")
                        .font(.system(size: 13))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(verde.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(verde.opacity(0.25), lineWidth: 1)
                )

                // MARK: 3. Lista de plataformas (datos fijos de GuiasData)
                ForEach(GuiasData.platforms) { plataforma in
                    VStack(alignment: .leading, spacing: 12) {

                        // Recuadro con el logo y la etiqueta de verificada
                        ZStack(alignment: .topLeading) {
                            Group {
                                if UIImage(named: plataforma.logo) != nil {
                                    Image(plataforma.logo)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 70)
                                } else {
                                    // Si el logo aún no está en Assets, se muestra la inicial
                                    Text(String(plataforma.nombre.prefix(1)))
                                        .font(.system(size: 48, weight: .bold, design: .serif))
                                        .foregroundStyle(verde)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .background(fondo)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                            Text("✓ VERIFICADA")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(verde)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(verde.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .padding(10)
                        }

                        // Nombre
                        Text(plataforma.nombre)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)

                        // URL (al tocarla abre el sitio en Safari)
                        if let url = URL(string: plataforma.url) {
                            Link(destination: url) {
                                HStack(spacing: 4) {
                                    Text(plataforma.url.replacingOccurrences(of: "https://", with: ""))
                                    Image(systemName: "arrow.up.right")
                                }
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(verde)
                            }
                        }
                    }
                    .padding(14)
                    .background(tarjeta)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(borde, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(fondo.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        VerifiedPlatformsView()
    }
}

