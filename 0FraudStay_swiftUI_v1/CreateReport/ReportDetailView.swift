//  ReportDetailView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 29/09/26.
//

import SwiftUI
struct ReportDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let reporte: DTOReporteResponse
    
    private let fondo = Color("FondoApp")
    private let textoPrincipal = Color(.black)
    private let textoGris = Color(.lightGray)
    private let verde = Color("VerificateColor")
    private let rojo = Color("BrandPrimaryColor")
    private let revision = Color("ReviewColor")
    private let borde = Color("Border")
    
    private func colorDeEstado(_ estado: String) -> Color {
        switch estado.uppercased() {
        case "FRAUDE": return rojo
        case "EN REVISIÓN": return revision
        default: return Color.gray
        }
    }
    
    private func iconoDeEstado(_ estado: String) -> String {
        switch estado.uppercased() {
        case "FRAUDE": return "exclamationmark.triangle.fill"
        case "EN REVISIÓN": return "clock.fill"
        default: return "questionmark.circle.fill"
        }
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                TabView {
                    AsyncImage(url: reporte.fotoURLCompleta) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else if phase.error != nil {
                            Color.gray.opacity(0.3)
                                .overlay(Image(systemName: "photo").foregroundStyle(.gray))
                        } else {
                            ProgressView()
                        }
                    }
                }
                .frame(height: 220)
                .tabViewStyle(.page)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Estado y Monto Defraudado
                HStack(alignment: .center) {
                    HStack(spacing: 6) {
                        Image(systemName: iconoDeEstado(reporte.estado))
                            .foregroundStyle(colorDeEstado(reporte.estado))
                        Text(reporte.estado)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(colorDeEstado(reporte.estado))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(colorDeEstado(reporte.estado).opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Spacer()
                    
                }
                
                // Título y Tipo de Fraude
                VStack(alignment: .leading, spacing: 8) {
                    Text(String(reporte.tipoFraudeId))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(rojo)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(rojo.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    Text(reporte.nombre)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(textoPrincipal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Divider()
                
                // Información General
                Grid(alignment: .leading, horizontalSpacing: 24, verticalSpacing: 12) {
                    GridRow {
                        Label("Plataforma", systemImage: "globe")
                            .foregroundStyle(textoGris)
                        Text(String(reporte.fuenteId))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(textoPrincipal)
                    }
                    GridRow {
                        Label("Ubicación", systemImage: "mappin.and.ellipse")
                            .foregroundStyle(textoGris)
                        Text(reporte.zona ?? "No especificada")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(textoPrincipal)
                    }
                    GridRow {
                        Label("Fecha", systemImage: "calendar")
                            .foregroundStyle(textoGris)
                        // Usa la propiedad computada 'fecha' ("YYYY-MM-DD") o 'createdAt' directo
                        Text(reporte.fecha)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(textoPrincipal)
                    }
                    .font(.system(size: 13))
                    
                    Divider()
                    
                    // Descripción
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descripción de los hechos")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(textoPrincipal)
                        Text(reporte.descripcion.isEmpty ? "Sin descripción disponible." : reporte.descripcion)
                            .font(.system(size: 14))
                            .foregroundStyle(textoPrincipal)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Divider()
                    
                    // Perfil Reportado
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Perfil del estafador / Contacto")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(textoPrincipal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Contacto / Ofertanter:")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(textoGris)
                                Text(reporte.contactoOfetante ?? "No proporcionado")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(textoPrincipal)
                            }
                            
                            if let precio = reporte.precio {
                                HStack {
                                    Text("Monto solicitado:")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(textoGris)
                                    Text(precio, format: .currency(code: "MXN"))
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(textoPrincipal)
                                }
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(fondo)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Divider()
                    
                    // Evidencias del fraude
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Evidencias del fraude")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(textoPrincipal)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                
                                // 1. Datos Generales (Ubicación y Fecha)
                                VStack(spacing: 10) {
                                    HStack {
                                        Label("Ubicación", systemImage: "mappin.and.ellipse")
                                            .foregroundStyle(textoGris)
                                        Spacer()
                                        Text(reporte.zona ?? "No especificada")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(textoPrincipal)
                                    }
                                    
                                    HStack {
                                        Label("Fecha", systemImage: "calendar")
                                            .foregroundStyle(textoGris)
                                        Spacer()
                                        Text(reporte.fecha)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(textoPrincipal)
                                    }
                                }
                                .font(.system(size: 13))
                                
                                Divider()
                                
                                // 2. Descripción de los Hechos
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Descripción de los hechos")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(textoPrincipal)
                                    
                                    Text(reporte.descripcion.isEmpty ? "Sin descripción disponible." : reporte.descripcion)
                                        .font(.system(size: 14))
                                        .foregroundStyle(textoPrincipal)
                                        .lineSpacing(4)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Divider()
                                
                                // 3. Perfil del Estafador / Contacto
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Perfil del estafador / Contacto")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(textoPrincipal)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text("Contacto / Ofertante:")
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundStyle(textoGris)
                                            Text(reporte.contactoOfetante ?? "No proporcionado")
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundStyle(textoPrincipal)
                                        }
                                        
                                        if let precio = reporte.precio {
                                            HStack {
                                                Text("Monto solicitado:")
                                                    .font(.system(size: 13, weight: .medium))
                                                    .foregroundStyle(textoGris)
                                                Text(precio, format: .currency(code: "MXN"))
                                                    .font(.system(size: 13, weight: .semibold))
                                                    .foregroundStyle(textoPrincipal)
                                            }
                                        }
                                    }
                                    .padding(12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(fondo)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                
                                Divider()
                                
                                // 4. Evidencias
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Evidencias del fraude")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(textoPrincipal)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            if let url = reporte.fotoURLCompleta {
                                                AsyncImage(url: url) { fase in
                                                    switch fase {
                                                    case .success(let imagen):
                                                        imagen
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                    case .failure:
                                                        Rectangle()
                                                            .fill(borde)
                                                            .overlay(
                                                                Image(systemName: "photo")
                                                                    .foregroundStyle(textoGris)
                                                            )
                                                    case .empty:
                                                        Rectangle()
                                                            .fill(borde)
                                                            .overlay(ProgressView())
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                                .frame(width: 200, height: 140)
                                                .clipped()
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            } else {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(borde, style: StrokeStyle(lineWidth: 1, dash: [4]))
                                                    .background(fondo.clipShape(RoundedRectangle(cornerRadius: 12)))
                                                    .frame(width: 200, height: 140)
                                                    .overlay(
                                                        VStack(spacing: 6) {
                                                            Image(systemName: "photo.badge.plus")
                                                                .font(.system(size: 20))
                                                                .foregroundStyle(textoGris)
                                                            Text("Sin evidencia")
                                                                .font(.system(size: 11))
                                                                .foregroundStyle(textoGris)
                                                        }
                                                    )
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(16)
                        }
                    }
                }
            }
        }
    }
}
