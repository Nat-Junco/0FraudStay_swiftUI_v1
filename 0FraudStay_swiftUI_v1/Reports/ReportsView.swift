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

// SERVICIO API (BACKEND)
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

// VIEWMODEL
@MainActor
class MyReportsViewModel: ObservableObject {
    @Published var reportes: [UserReport] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Cambia a 'true' cuando tengas listo tu backend real
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
            try? await Task.sleep(nanoseconds: 400_000_000) // Simula tiempo de respuesta
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

// VISTA SWIFTUI
struct MyReportsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MyReportsViewModel()
    @State private var filtroSeleccionado: ReportStatus = .todos

    private var reportesFiltrados: [UserReport] {
        if filtroSeleccionado == .todos {
            return viewModel.reportes
        }
        return viewModel.reportes.filter { $0.estado == filtroSeleccionado }
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
                    MetricCard(valor: "\(viewModel.reportes.count)", titulo: "TOTAL", colorTexto: .black)
                    MetricCard(valor: "\(viewModel.reportes.filter { $0.estado == .fraude }.count)", titulo: "FRAUDE CONF.", colorTexto: .red)
                    MetricCard(valor: "\(viewModel.reportes.filter { $0.estado == .enRevision }.count)", titulo: "EN REVISIÓN", colorTexto: .orange)
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
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 30)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 8) {
                        Text(error)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.red)
                        Button("Reintentar") {
                            Task { await viewModel.cargarReportes() }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
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
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.cargarReportes()
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
    }
}
