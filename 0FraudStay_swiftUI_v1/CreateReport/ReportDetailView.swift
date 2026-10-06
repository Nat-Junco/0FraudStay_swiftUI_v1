//
//  ReportDetailView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 29/09/26.
//
//  Detalle de un reporte real (DTOReporteResponse). Los nombres de
//  plataforma / tipo de fraude / tipo de propiedad vienen de los
//  catálogos del back a través de ReportesViewModel.
//

import SwiftUI
import MapKit

struct ReportDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vm: ReportesViewModel

    let reporte: DTOReporteResponse

    private let fondo = Color("FondoApp")
    private let textoPrincipal = Color(.black)
    private let textoGris = Color(.lightGray)
    private let verde = Color("VerificateColor")
    private let rojo = Color("BrandPrimaryColor")
    private let revision = Color("ReviewColor")
    private let borde = Color("Border")

    private var textoEstado: String {
        reporte.estadoId == 3 ? "FRAUDE" : reporte.nombreEstado
    }

    private var colorDeEstado: Color {
        switch reporte.estadoId {
        case 3: return rojo            // Verificado = fraude confirmado
        case 2: return revision        // En revisión
        case 4: return Color.gray      // Rechazado
        default: return Color.gray     // Pendiente / Cerrado
        }
    }

    private var iconoDeEstado: String {
        switch reporte.estadoId {
        case 3: return "exclamationmark.triangle.fill"
        case 2: return "clock.fill"
        case 4: return "xmark.circle.fill"
        case 5: return "checkmark.circle.fill"
        default: return "questionmark.circle.fill"
        }
    }

    private var coordenada: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: reporte.latitud, longitude: reporte.longitud)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {

                // Carrusel: portada y evidencia
                TabView {
                    ForEach([reporte.fotoURLCompleta, reporte.evidenciaURLCompleta], id: \.self) { url in
                        AsyncImage(url: url) { fase in
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
                        Image(systemName: iconoDeEstado)
                            .foregroundStyle(colorDeEstado)
                        Text(textoEstado)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(colorDeEstado)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(colorDeEstado.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Monto defraudado")
                            .font(.system(size: 11))
                            .foregroundStyle(textoGris)
                        Text(reporte.precioTexto)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(rojo)
                    }
                }

                // Título y Tipo de Fraude
                VStack(alignment: .leading, spacing: 8) {
                    Text(vm.nombreTipoFraude(reporte.tipoFraudeId).uppercased())
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(rojo)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(rojo.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    Text(reporte.nombre)
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
                        Text(vm.nombreFuente(reporte.fuenteId))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(textoPrincipal)
                    }
                    GridRow {
                        Label("Propiedad", systemImage: "house")
                            .foregroundStyle(textoGris)
                        Text(vm.nombreTipoPropiedad(reporte.tipoPropiedadId))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(textoPrincipal)
                    }
                    GridRow {
                        Label("Ubicación", systemImage: "mappin.and.ellipse")
                            .foregroundStyle(textoGris)
                        Text(reporte.zona ?? "Sin zona registrada")
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
                    GridRow {
                        Label("Folio", systemImage: "number")
                            .foregroundStyle(textoGris)
                        Text(reporte.folio)
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
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
                            Text("Contacto:")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(textoGris)
                            Text(reporte.contactoOfertante ?? "No especificado")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(textoPrincipal)
                        }
                        HStack {
                            Text("Publicado en:")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(textoGris)
                            Text(vm.nombreFuente(reporte.fuenteId))
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

                // Evidencia
                VStack(alignment: .leading, spacing: 12) {
                    Text("Evidencia del fraude")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(textoPrincipal)

                    AsyncImage(url: reporte.evidenciaURLCompleta) { fase in
                        if let imagen = fase.image {
                            imagen
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if fase.error != nil {
                            Rectangle()
                                .fill(fondo)
                                .overlay(
                                    VStack(spacing: 6) {
                                        Image(systemName: "photo")
                                            .font(.system(size: 20))
                                            .foregroundStyle(textoGris)
                                        Text("Sin evidencia")
                                            .font(.system(size: 11))
                                            .foregroundStyle(textoGris)
                                    }
                                )
                        } else {
                            Rectangle()
                                .fill(borde)
                                .overlay(ProgressView())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Divider()

                // Ubicación en el mapa
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ubicación")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(textoPrincipal)

                    Map(initialPosition: .region(MKCoordinateRegion(
                        center: coordenada,
                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))) {
                        Marker(reporte.nombre, coordinate: coordenada)
                            .tint(rojo)
                    }
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(16)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
