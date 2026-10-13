//
//  AllrReportsView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//

//  Consultar reportes (GET /reportes) con «extend» Buscar reportes
//  (filtro local por texto y estado) y Consultar detalle (ReportDetailView).
//

import SwiftUI
struct AllReportsView: View {
    @EnvironmentObject var vm: ReportesViewModel

    private let rojo = Color("BrandPrimaryColor")
    private let verde = Color("VerificateColor")
    private let revision = Color("ReviewColor")
    private let fondo = Color("FondoApp")
    private let tarjeta = Color(.secondarySystemGroupedBackground)
    private let borde = Color("Border")
    
    @State private var busqueda = ""
    @State private var filtro = "Todos"
    
    private let filtros = ["Todos", "Fraude", "No es fraude"]

    private var filtrados: [DTOReporteResponse] {
        vm.todos.filter { r in
            let coincideTexto = busqueda.esVacio
                || r.nombre.localizedCaseInsensitiveContains(busqueda)
                || (r.zona ?? "").localizedCaseInsensitiveContains(busqueda)
                || vm.nombreFuente(r.fuenteId).localizedCaseInsensitiveContains(busqueda)
                || vm.nombreTipoFraude(r.tipoFraudeId).localizedCaseInsensitiveContains(busqueda)

            // ids de la tabla `estado`: 1 Pendiente, 2 En revisión, 3 Verificado (= fraude)
            let coincideEstado: Bool
            switch filtro {
            case "Fraude":       coincideEstado = r.estadoId == 2
            case "No es fraude": coincideEstado = r.estadoId == 3
            default:             coincideEstado = true
            }

            return coincideTexto && coincideEstado && r.estadoId != 1
        }
    }

    /// Texto del estado como lo usa el diseño ("FRAUDE" para verificados)
    private func estadoTexto(_ r: DTOReporteResponse) -> String {
        r.nombreEstado
    }

    private func colorDe(_ estado: String) -> Color {
        switch estado {
        case "FRAUDE":       return rojo
        case "NO ES FRAUDE": return verde
        case "EN REVISIÓN":  return revision
        default:             return Color.gray
        }
    }

    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("0FRAUD STAY")
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
                if vm.isLoading && vm.todos.isEmpty {
                    ProgressView("Cargando reportes…")
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                } else if let error = vm.errorMessage, vm.todos.isEmpty {
                    VStack(spacing: 12) {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Reintentar") { Task { await vm.cargarTodo() } }
                            .buttonStyle(.borderedProminent)
                            .tint(rojo)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                } else if filtrados.isEmpty {
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
                            ReportDetailView(reporte: reporte)
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                ZStack(alignment: .top) {
                                    AsyncImage(url: reporte.fotoURLCompleta) { fase in
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
                                        Text(estadoTexto(reporte))
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundStyle(colorDe(estadoTexto(reporte)))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(tarjeta.opacity(0.85))
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(colorDe(estadoTexto(reporte)).opacity(0.4), lineWidth: 1)
                                            )
                                        Spacer()
                                        Text(reporte.precioTexto)
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
                                    Text(reporte.nombre)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.primary)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                    HStack(alignment: .top, spacing: 8) {
                                        Text(vm.nombreFuente(reporte.fuenteId))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("·")
                                        Text(reporte.zona ?? "Sin zona")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("·")
                                        Text(reporte.fecha)
                                            .frame(width: 80, alignment: .leading)
                                    }
                                    .font(.system(size: 13))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.leading)
                                    HStack {
                                        Text(vm.nombreTipoFraude(reporte.tipoFraudeId))
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
        .refreshable { await vm.cargarTodo() }
        .task { if vm.todos.isEmpty { await vm.cargarTodo() } }
    }
}
#Preview {
    NavigationStack {
        AllReportsView()
            .environmentObject(ReportesViewModel())
    }
}
