//
//  ReportDetailView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 29/09/26.
//

import SwiftUI
struct ReportDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let reporte: ReportDetail
    
    private let fondo = Color("FondoApp")
    private let textoPrincipal = Color(.black)
    private let textoGris = Color(.lightGray)
    private let verde = Color("VerificateColor")
    private let rojo = Color("BrandPrimaryColor")
    private let borde = Color("Border")
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                TabView {
                    ForEach(reporte.imageUrls, id: \.self) { urlString in
                        AsyncImage(url: URL(string: urlString)) { fase in
                            if let imagen = fase.image {
                                imagen
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Rectangle().fill(borde)
                            }
                        }
                    }
                }
                .frame(height: 220)
                .tabViewStyle(.page)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Estado y Monto Defraudado
                HStack(alignment: .center) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(verde)
                        Text(reporte.estado)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(verde)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(verde.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Monto defraudado")
                            .font(.system(size: 11))
                            .foregroundStyle(textoGris)
                        Text(reporte.montoDefraudado)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(rojo)
                    }
                }
                
                // Título y Tipo de Fraude
                VStack(alignment: .leading, spacing: 8) {
                    Text(reporte.tipoFraude)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(rojo)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(rojo.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    Text(reporte.titulo)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(textoPrincipal)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Divider()
                
                // Información General
                Grid(alignment: .leading, horizontalSpacing: 24, verticalSpacing: 12) {
                    GridRow {
                        Label("Plataforma", systemImage: "globe")
                            .foregroundStyle(textoGris)
                        Text(reporte.plataforma)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(textoPrincipal)
                    }
                    GridRow {
                        Label("Ubicación", systemImage: "mappin.and.ellipse")
                            .foregroundStyle(textoGris)
                        Text(reporte.ubicacion)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(textoPrincipal)
                    }
                    GridRow {
                        Label("Fecha", systemImage: "calendar")
                            .foregroundStyle(textoGris)
                        Text(reporte.fecha)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(textoPrincipal)
                    }
                }
                .font(.system(size: 13))
                
                Divider()
                
                // Descripción
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descripción de los hechos")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(textoPrincipal)
                    Text(reporte.descripcion)
                        .font(.system(size: 14))
                        .foregroundStyle(textoPrincipal)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Divider()
                
                // Perfil Reportado
                VStack(alignment: .leading, spacing: 12) {
                    Text("Perfil del estafador")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(textoPrincipal)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Nombre / Alias:")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(textoGris)
                            Text(reporte.nombreEstafador)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(textoPrincipal)
                        }
                        HStack {
                            Text("Enlace:")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(textoGris)
                            Text(reporte.linkEstafador)
                                .font(.system(size: 13))
                                .foregroundStyle(.blue)
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(fondo)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Divider()
                VStack(alignment: .leading, spacing: 12) {
                    Text("Evidencias del fraude")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(textoPrincipal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<2, id: \.self) { indice in
                                if let evidencias = reporte.evidenciaUrls,
                                   indice < evidencias.count {
                                    AsyncImage(url: URL(string: evidencias[indice])) { fase in
                                        if let imagen = fase.image {
                                            imagen
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } else {
                                            Rectangle()
                                                .fill(borde)
                                                .overlay(ProgressView())
                                        }
                                    }
                                    .frame(width: 200, height: 140)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                } else {
                                    // Placeholder si no hay evidencia subida
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
            }
            .padding(16)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Atrás")
                    }
                    .foregroundStyle(textoPrincipal)
                }
            }
        }
    }
}
#Preview {
    NavigationStack {
        ReportDetailView(reporte: ReportDetail(
            id: "1",
            imageUrls: ["https://images.unsplash.com/photo-1512917774080-9991f1c4c750"],
            estado: "VERIFICADO",
            tipoFraude: "PROPIEDAD FANTASMA",
            titulo: "Depto amueblado Condesa — nunca existió",
            plataforma: "Facebook Marketplace",
            ubicacion: "Condesa, CDMX",
            fecha: "12 mar 2026",
            montoDefraudado: "$4,200 MXN",
            descripcion: "Publicación de departamento amueblado en Condesa a un precio bajo. Al contactar al supuesto dueño, solicitó un anticipo por transferencia para apartar la propiedad. Después de realizar el pago, bloqueó la comunicación.",
            nombreEstafador: "Carlos R. / 'Rentas CDMX'",
            linkEstafador: "facebook.com/marketplace/item/839201",
            evidenciaUrls: [
                "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c",
                "https://images.unsplash.com/photo-1586281380349-632531db7ed4"
            ]
        ))
    }
}
