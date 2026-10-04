//
//  AllrReportsView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//

import SwiftUI
struct AllReportsView: View {
    private let rojo = Color("BrandPrimaryColor")
    private let verde = Color("VerificateColor")
    private let revision = Color("ReviewColor")
    private let fondo = Color("FondoApp")
    private let tarjeta = Color(.secondarySystemGroupedBackground)
    private let borde = Color("Border")
    
    @State private var busqueda = ""
    @State private var filtro = "Todos"
    
    private let filtros = ["Todos", "Fraude", "En Revisión", "Pendiente"]

    private let reportes: [ReporteEjemplo] = [
        ReporteEjemplo(imagen: "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800",
                       estado: "FRAUDE", precio: "$4,200",
                       titulo: "Depto amueblado Condesa — nunca existió",
                       plataforma: "Facebook Marketplace", ubicacion: "Condesa, Ciudad de México",
                       fecha: "12 mar 2026", etiqueta: "Propiedad Fantasma"),
        ReporteEjemplo(imagen: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800",
                       estado: "FRAUDE", precio: "$8,500",
                       titulo: "Casa en Tulum — fotos robadas de Airbnb",
                       plataforma: "Airbnb (cuenta clonada)", ubicacion: "Aldea Zama, Tulum",
                       fecha: "28 feb 2026", etiqueta: "Clonación de Anuncio"),
        ReporteEjemplo(imagen: "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800",
                       estado: "EN REVISIÓN", precio: "$14,000",
                       titulo: "Penthouse Roma Norte — cambio de último minuto",
                       plataforma: "WhatsApp", ubicacion: "Roma Norte, Ciudad de México",
                       fecha: "1 mar 2026", etiqueta: "Cambio de Propiedad"),
        ReporteEjemplo(imagen: "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800",
                       estado: "PENDIENTE", precio: "$6,200",
                       titulo: "Studio Polanco — propietario inexistente",
                       plataforma: "Inmuebles24", ubicacion: "Polanco, Ciudad de México",
                       fecha: "4 feb 2026", etiqueta: "Anfitrión Falso")
    ]
    
    private var filtrados: [ReporteEjemplo] {
        reportes.filter { r in
            let coincideTexto = busqueda.isEmpty
                || r.titulo.localizedCaseInsensitiveContains(busqueda)
                || r.ubicacion.localizedCaseInsensitiveContains(busqueda)
                || r.plataforma.localizedCaseInsensitiveContains(busqueda)
            
            let coincideEstado: Bool
            switch filtro {
            case "Fraude": coincideEstado = r.estado == "FRAUDE"
            case "En Revisión": coincideEstado = r.estado == "EN REVISIÓN"
            case "Pendiente":  coincideEstado = r.estado == "PENDIENTE"
            default:            coincideEstado = true
            }
            return coincideTexto && coincideEstado
        }
    }
  
    private func colorDe(_ estado: String) -> Color {
        switch estado {
        case "FRAUDE":  return rojo
        case "EN REVISIÓN": return revision
        default:            return Color.gray
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("OFRAUD STAY")
                            .font(.system(size: 12, weight: .bold))
                            .kerning(1.2)
                            .foregroundStyle(rojo)
                        Text("Reportes")
                            .font(.system(size: 22, weight: .bold, design: .serif))
                            .foregroundStyle(.primary)
                    }
                    Spacer()
                    Image("appLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .background(fondo)
                }
                .padding(.top, 8)
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24, weight: .semibold))
                    
                    TextField("Buscar por colonia, título…", text: $busqueda)
                        .font(.system(size: 16))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    if !busqueda.isEmpty {
                        Button {
                            busqueda = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 54)
                .background(tarjeta)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(borde, lineWidth: 1)
                )
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filtros, id: \.self) { opcion in
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    filtro = opcion
                                }
                            } label: {
                                Text(opcion)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(filtro == opcion ? Color.white : Color.secondary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 9)
                                    .background(filtro == opcion ? rojo : tarjeta)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(filtro == opcion ? Color.clear : borde, lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                if filtrados.isEmpty {
                    VStack(spacing: 8) {
                        Text("Sin resultados")
                            .font(.system(size: 17, weight: .semibold))
                        Text("No hay reportes que coincidan con tu búsqueda.")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                } else {
                    ForEach(filtrados) { reporte in
                        NavigationLink {
                            ReportDetailView(reporte: ReportDetail(from: reporte))
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                ZStack(alignment: .top) {
                                    AsyncImage(url: URL(string: reporte.imagen)) { fase in
                                        if let imagen = fase.image {
                                            imagen.resizable().scaledToFill()
                                        } else {
                                            borde
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 150)
                                    .clipped()
                                    .contentShape(RoundedRectangle(cornerRadius: 18))
                                    HStack {
                                        Text(reporte.estado)
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundStyle(colorDe(reporte.estado))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(tarjeta.opacity(0.85))
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(colorDe(reporte.estado).opacity(0.4), lineWidth: 1)
                                            )
                                        Spacer()
                                        Text(reporte.precio)
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundStyle(rojo)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.black.opacity(0.7))
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                    }
                                    .padding(12)
                                }
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(reporte.titulo)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.primary)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                    HStack(alignment: .top, spacing: 8) {
                                        Text(reporte.plataforma)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("·")
                                        Text(reporte.ubicacion)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("·")
                                        Text(reporte.fecha)
                                            .frame(width: 60, alignment: .leading)
                                    }
                                    .font(.system(size: 13))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.leading)
                                    HStack {
                                        Text(reporte.etiqueta)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundStyle(.secondary)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(fondo)
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                        Spacer()
                                    }
                                }
                                .padding(16)
                            }
                            .background(tarjeta)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(borde, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(fondo.ignoresSafeArea())
    }
}
struct ReporteEjemplo: Identifiable {
    let id = UUID()
    let imagen: String
    let estado: String
    let precio: String
    let titulo: String
    let plataforma: String
    let ubicacion: String
    let fecha: String
    let etiqueta: String
}

extension ReportDetail {
    init(from ejemplo: ReporteEjemplo) {
        self.id = ejemplo.id.uuidString
        self.imageUrls = [ejemplo.imagen]
        self.estado = ejemplo.estado
        self.tipoFraude = ejemplo.etiqueta.uppercased()
        self.titulo = ejemplo.titulo
        self.plataforma = ejemplo.plataforma
        self.ubicacion = ejemplo.ubicacion
        self.fecha = ejemplo.fecha
        self.montoDefraudado = ejemplo.precio
        self.descripcion = "Publicación con irregularidades detectadas. No realices transferencias ni depósitos de anticipo sin antes verificar la autenticidad del inmueble."
        self.nombreEstafador = "En investigación"
        self.linkEstafador = "No especificado"
    }
}
#Preview {
    NavigationStack {
        AllReportsView()
    }
}
