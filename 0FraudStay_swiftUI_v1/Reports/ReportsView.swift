//
//  ReportsView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - MODELO DE DATOS
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

// EXTENSIÓN PARA MAPEAR DTO A USERREPORT
extension UserReport {
    init(dto: DTOReporteResponse, plataforma: String) {
        let estado: ReportStatus
        switch dto.estadoId {
        case 2:
            estado = .enRevision
        case 3:
            estado = .fraude
        default:
            estado = .pendiente
        }

        let formato = NumberFormatter()
        formato.numberStyle = .currency
        formato.locale = Locale(identifier: "es_MX")

        self.id = String(dto.id)
        self.folio = "RS-\(String(format: "%04d", dto.id))"
        self.titulo = dto.nombre
        self.plataforma = plataforma
        self.ubicacion = dto.zona ?? "Sin zona"
        self.fecha = dto.fecha
        self.monto = (formato.string(from: NSNumber(value: dto.precio ?? 0)) ?? "$0") + " MXN"
        self.estado = estado
        self.esEditable = dto.esEditable
        self.imageUrl = dto.fotoURLCompleta?.absoluteString
    }
}

enum ReportStatus: String, Codable, CaseIterable {
    case todos = "Todos"
    case fraude = "Fraude"
    case enRevision = "En revisión"
    case pendiente = "Pendiente"
    
    var colorTexto: Color {
        switch self {
        case .todos:
            return .white
        case .pendiente:
            return Color("MissingColor")
        case .enRevision:
            return Color("ReviewColor")
        case .fraude:
            return Color.red
        }
    }
    
    var colorFondo: Color {
        switch self {
        case .todos:
            return Color.red
        case .pendiente:
            return Color.gray.opacity(0.15)
        case .enRevision:
            return Color.orange.opacity(0.15)
        case .fraude:
            return Color.red.opacity(0.12)
        }
    }
}

// MARK: - SERVICIO API
class ReportService {
    private let baseURL = "https://api.tudominio.com/v1"
    
    func fetchUserReports(token: String) async throws -> [UserReport] {
        guard let url = URL(string: "\(baseURL)/reports/me") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([UserReport].self, from: data)
    }
}

// MARK: - VIEWMODEL
@MainActor
class MyReportsViewModel: ObservableObject {
    @Published var reportes: [UserReport] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let usarBackendReal = false
    private let service = ReportService()
    
    func cargarReportes() async {
        self.isLoading = true
        self.errorMessage = nil
        
        if usarBackendReal {
            do {
                let token = "TOKEN_JWT_AQUI"
                self.reportes = try await service.fetchUserReports(token: token)
            } catch {
                self.errorMessage = "No se pudo conectar con el servidor."
            }
        } else {
            // MODO ESTÁTICO / MOCK
            try? await Task.sleep(nanoseconds: 400_000_000)
            self.reportes = [
                UserReport(id: "1", folio: "RS-2026-0089", titulo: "Depto Condesa — anfitrión desapareció tras cobro", plataforma: "Facebook Marketplace", ubicacion: "CDMX", fecha: "12 mar 2026", monto: "$8,500 MXN", estado: .enRevision, esEditable: true, imageUrl: nil),
                UserReport(id: "2", folio: "RS-2026-0086", titulo: "Penthouse Roma Norte — cambio de último minuto", plataforma: "WhatsApp", ubicacion: "CDMX", fecha: "1 mar 2026", monto: "$14,000 MXN", estado: .pendiente, esEditable: true, imageUrl: nil),
                UserReport(id: "3", folio: "RS-2026-0071", titulo: "Casa Tulum — fotos falsas, nunca entregaron llaves", plataforma: "Airbnb", ubicacion: "Tulum", fecha: "18 feb 2026", monto: "$22,000 MXN", estado: .fraude, esEditable: false, imageUrl: nil),
                UserReport(id: "4", folio: "RS-2026-0058", titulo: "Studio Polanco — propietario inexistente", plataforma: "Inmuebles24", ubicacion: "CDMX", fecha: "4 feb 2026", monto: "$6,200 MXN", estado: .fraude, esEditable: false, imageUrl: nil)
            ]
        }
        
        self.isLoading = false
    }
}

// MARK: - VISTAS
struct MyReportsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vm: ReportesViewModel
    @State private var filtroSeleccionado: ReportStatus = .todos
    
    private var reportes: [UserReport] {
        vm.mios.map {
            UserReport(dto: $0, plataforma: vm.nombreFuente($0.fuenteId))
        }
    }
    
    private var perdidas: String {
        let confirmados = vm.mios.filter { $0.estadoId == 3 }
        let total: Double = confirmados.reduce(0.0) { suma, r in suma + (r.precio ?? 0) }
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
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("MI PERFIL")
                        .font(.system(size: 11, weight: .bold))
                        .kerning(0.8)
                        .foregroundStyle(Color("BrandPrimaryColor"))
                    
                    Text("Mis reportes")
                        .font(.system(size: 22, weight: .bold))
                }
                
                // Tarjetas Métricas
                HStack(spacing: 8) {
                    MetricCard(valor: "\(reportes.count)", titulo: "TOTAL", colorTexto: .black)
                    MetricCard(valor: "\(reportes.filter { $0.estado == .fraude }.count)", titulo: "FRAUDE CONF.", colorTexto: .red)
                    MetricCard(valor: "\(reportes.filter { $0.estado == .enRevision }.count)", titulo: "EN REVISIÓN", colorTexto: .orange)
                    MetricCard(valor: perdidas, titulo: "PÉRDIDAS", colorTexto: .red)
                }

                // Filtros
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
                if vm.isLoading && reportes.isEmpty {
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
                } else if reportes.isEmpty {
                    ContentUnavailableView("Sin reportes", systemImage: "tray", description: Text("Aún no has creado ningún reporte."))
                } else {
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
        .task {
            await vm.cargarTodo()
        }
        .refreshable {
            await vm.cargarTodo()
        }
    }
}

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
        VStack(alignment: .leading, spacing: 12) {
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
            
            if reporte.esEditable {
                Divider()
                    .padding(.vertical, 2)
                
                HStack(spacing: 10) {
                    Button {
                        // Falta funcionalidad
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 12, weight: .bold))
                            Text("Editar")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(Color.gray.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                        )
                    }
                    
                    Button {
                        // Falta funcionalidad
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "trash")
                                .font(.system(size: 12, weight: .bold))
                            Text("Eliminar")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundStyle(Color.red.opacity(0.85))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(Color.red.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red.opacity(0.25), lineWidth: 1)
                        )
                    }
                }
            } else {
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
;