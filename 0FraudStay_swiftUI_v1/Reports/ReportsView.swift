//
//  ReportsView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import Foundation
import SwiftUI
import Combine

// MODELO DE DATOS
struct UserReport: Codable, Identifiable {
    let id: String
    let folio: String
    let titulo: String
    let plataforma: String
    let ubicacion: String
    let fecha: String
    let monto: String
    let estado: ReportStatus
    let esEditable: Bool
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, folio, titulo, plataforma, ubicacion, fecha, monto, estado
        case esEditable = "es_editable"
        case imageUrl = "image_url"
    }
}

enum ReportStatus: String, Codable, CaseIterable {
    case todos = "Todos"
    case pendiente = "Pendiente"
    case enRevision = "En revisión"
    case fraude = "Fraude"
    
    var colorTexto: Color {
        switch self {
        case .todos: return .white
        case .pendiente: return Color(red: 0.45, green: 0.45, blue: 0.48)
        case .enRevision: return Color(red: 0.85, green: 0.55, blue: 0.15)
        case .fraude: return Color("BrandPrimaryColor", bundle: nil) != Color.clear ? Color("BrandPrimaryColor") : .red
        }
    }
    
    var colorFondo: Color {
        switch self {
        case .todos: return Color("BrandPrimaryColor", bundle: nil) != Color.clear ? Color("BrandPrimaryColor") : .red
        case .pendiente: return Color(red: 0.94, green: 0.94, blue: 0.96)
        case .enRevision: return Color(red: 1.0, green: 0.95, blue: 0.88)
        case .fraude: return Color.red.opacity(0.1)
        }
    }
}

extension UserReport{
    init(dto:DTOReporteResponse, plataforma: String){
        let estado: ReportStatus
        switch dto.estadoId{
        case 2: estado = .enRevision
        case 3: estado = .fraude
        default: estado = .pendiente
        }
        let formato = NumberFormatter()
        formato.numberStyle = .currency
        formato.locale = Locale(identifier: "es_MX")
        
        self.init(
            id: String(dto.id),
            folio: "RS-\(String(format: "%04d",dto.id))",
            titulo: dto.nombre,
            plataforma: plataforma,
            ubicacion: dto.zona ?? "Sin zona",
            fecha: dto.fecha,
            monto: (formato.string(from: NSNumber(value: dto.precio ?? 0)) ?? "$0") + "MXN",
            estado: estado,
            esEditable: dto.esEditable,
            imageUrl: dto.fotoURLCompleta?.absoluteString
            
            
        )
    }
}

// VISTA SWIFTUI
struct MyReportsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vm : ReportesViewModel
    @State private var filtroSeleccionado: ReportStatus = .todos
    
    private var reportes: [UserReport] {
        vm.mios.map {
            UserReport(dto: $0, plataforma: vm.nombreFuente($0.fuenteId))
        }
    }
    
    private var perdidas: String{
        let confirmados = vm.mios.filter { $0.estadoId == 3 }
        let total: Double = confirmados.reduce (0.0) { suma, r in suma + (r.precio ?? 0)}
        return total >= 1000 ? "$\(Int(total / 1000))k" : "$\(Int(total))"
        
    }

    private var reportesFiltrados: [UserReport] {
        if filtroSeleccionado == .todos {
            return reportes
        }
        return reportes.filter { $0.estado == filtroSeleccionado }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                
                // Cabecera
                VStack(alignment: .leading, spacing: 6) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.red)
                    }
                    .padding(.bottom, 4)
                    
                    Text("MI PERFIL")
                        .font(.system(size: 11, weight: .bold))
                        .kerning(0.8)
                        .foregroundStyle(Color.gray)
                    
                    Text("Mis reportes")
                        .font(.system(size: 22, weight: .bold))
                }
                
                // Tarjetas Métricas
                HStack(spacing: 8) {
                    MetricCard(valor: "\(reportes.count)", titulo: "TOTAL", colorTexto: .black)
                    MetricCard(valor: "\(reportes.filter { $0.estado == .fraude }.count)", titulo: "FRAUDE CONF.", colorTexto: .red)
                    MetricCard(valor: "\(reportes.filter { $0.estado == .enRevision }.count)", titulo: "EN REVISIÓN", colorTexto: .orange)
                    MetricCard(valor: "$51k", titulo: "PÉRDIDAS", colorTexto: .red)
                }

                // Selector de Filtros
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ReportStatus.allCases, id: \.self) { status in
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    filtroSeleccionado = status
                                }
                            } label: {
                                Text(status.rawValue)
                                    .font(.system(size: 12, weight: .medium))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(filtroSeleccionado == status ? Color.red : Color.white)
                                    .foregroundStyle(filtroSeleccionado == status ? Color.white : Color.gray)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(filtroSeleccionado == status ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                    }
                }

                // Contenido principal
                if vm.isLoading && reportes.isEmpty{
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 30)
                } else if let error = vm.errorMessage, reportes.isEmpty {
                    VStack(spacing: 8) {
                        Text(error)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.red)
                        Button("Reintentar") {
                            Task { await vm.cargarTodo() }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                } else if reportes.isEmpty{
                    ContentUnavailableView("Sin reportes", systemImage: "tray", description: Text("Aún no has creado ningún reporte."))
                }
                
                else{
                    VStack(spacing: 12) {
                        ForEach(reportesFiltrados) { reporte in
                            ReportRowCard(reporte: reporte)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.98).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .task {
            await vm.cargarTodo()
        }
        .refreshable{
            await vm.cargarTodo()
        }
    }
}

// COMPONENTES SECUNDARIOS
struct MetricCard: View {
    let valor: String
    let titulo: String
    let colorTexto: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(valor)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(colorTexto)
            
            Text(titulo)
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(Color.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 4)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ReportRowCard: View {
    let reporte: UserReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.18))
                    .frame(width: 42, height: 42)
                    .overlay(
                        Image(systemName: "house.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.gray.opacity(0.7))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(reporte.titulo)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .lineLimit(2)
                    
                    Text("\(reporte.plataforma) · \(reporte.ubicacion) · \(reporte.fecha)")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.gray)
                }
                
                Spacer()
                
                Text(reporte.estado.rawValue.uppercased())
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(reporte.estado.colorTexto)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(reporte.estado.colorFondo)
                    .clipShape(Capsule())
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(reporte.monto)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(reporte.estado == .fraude ? Color.red : Color(red: 0.85, green: 0.35, blue: 0.2))
                
                Text(reporte.folio)
                    .font(.system(size: 10))
                    .foregroundStyle(Color.gray.opacity(0.8))
            }
            
            if !reporte.esEditable {
                Divider()
                    .padding(.vertical, 2)
                
                HStack(spacing: 4) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 9))
                    Text("Confirmado como fraude · ya no es editable")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundStyle(Color.green)
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        MyReportsView()
            .environmentObject(ReportesViewModel())
    }
}
