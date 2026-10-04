//
//  GuidesView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by Marbella Barba De Los Santos on 29/09/26.
//

import SwiftUI

struct GuidesView: View {

    // Colores: los de marca vienen de Assets; fondo, tarjetas y bordes son del sistema
    // (se adaptan solos a Modo Claro / Oscuro)
    private let rojo = Color("BrandPrimaryColor")
    private let verde = Color("VerificateColor")
    private let fondo = Color("FondoApp")
    private let tarjeta = Color(.secondarySystemGroupedBackground)
    private let borde = Color("Border")

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: 1. Encabezado
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("OFRAUD STAY")
                            .font(.system(size: 12, weight: .bold))
                            .kerning(1.2)
                            .foregroundStyle(rojo)
                    }
                    Spacer()
                    Image("appLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height:70)
                        .background(fondo)
                }

                // MARK: 2. Título
                VStack(alignment: .leading, spacing: 8) {
                    Text("Guías")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundStyle(.primary)
                    Text("Herramientas para rentar con seguridad")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)

                // MARK: 3. Tarjeta: Propiedades Verificadas
                NavigationLink {
                    VerifiedPlatformsView()
                } label: {
                    VStack(spacing: 0) {
                        
                        ZStack(alignment: .bottomLeading) {
                            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800")) { fase in
                                if let imagen = fase.image {
                                    imagen.resizable().scaledToFill()
                                } else {
                                    verde.opacity(0.4)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 130)
                            .clipped()

                            verde.opacity(0.6)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Plataformas Verificadas")
                                    .font(.system(size: 21, weight: .bold, design: .serif))
                                    .foregroundStyle(.white)
                                Text("Listado de plataformas confirmadas como legítimas por el equipo de 0Fraud Stay")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.white.opacity(0.92))
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                        }
                        .frame(height: 130)
                        .clipped()

                        // Etiquetas y flecha
                        HStack(spacing: 8) {
                            Text("\(GuiasData.platforms.count) propiedades")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(verde)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(verde.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text("✓ Verificadas")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(verde)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(verde.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        .padding(14)
                    }
                    .background(tarjeta)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(borde, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                }
                .buttonStyle(.plain)

                // MARK: 4. Tarjeta: Guía Antifraude
                NavigationLink {
                    AntiFraudGuideView()
                } label: {
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottomLeading) {
                            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800")) { fase in
                                if let imagen = fase.image {
                                    imagen.resizable().scaledToFill()
                                } else {
                                    rojo.opacity(0.4)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 130)
                            .clipped()

                            rojo.opacity(0.55)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Guía Antifraude")
                                    .font(.system(size: 21, weight: .bold, design: .serif))
                                    .foregroundStyle(.white)
                                Text("\(GuiasData.tips.count) tips concretos para detectar y evitar estafas en rentas vacacionales")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.white.opacity(0.92))
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                        }
                        .frame(height: 130)
                        .clipped()

                        HStack(spacing: 8) {
                            Text("\(GuiasData.tips.count) tips")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(rojo)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(rojo.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text("Esenciales")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(rojo)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(rojo.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        .padding(14)
                    }
                    .background(tarjeta)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(borde, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                }
                .buttonStyle(.plain)
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
        GuidesView()
    }
}

