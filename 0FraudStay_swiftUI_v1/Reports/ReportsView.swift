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

extension UserReport {
    init(dto: DTOReporteResponse, plataforma: String) {
        let estado: ReportStatus
        // Semáforo: 1 En revisión, 2 Fraude confirmado, 3 No es fraude
        switch dto.estadoId {
        case 2:
            estado = .fraude
        case 3:
            estado = .noFraude
        default:
            estado = .enRevision
        }

        // dto.id ya es String (UUID)
        self.id = dto.id
        
        // Muestra los primeros 8 caracteres del UUID como folio corto (ej. RS-413214E2)
        let uuidCorto = dto.id.prefix(8).uppercased()
        self.folio = "RS-\(uuidCorto)"
        
        self.titulo = dto.nombre
        self.plataforma = plataforma
        self.ubicacion = dto.zona ?? "Sin zona"
        self.fecha = dto.fecha
        self.monto = dto.precioTexto
        self.estado = estado
        self.esEditable = dto.esEditable
        self.imageUrl = dto.fotoURLCompleta?.absoluteString
    }
}

enum ReportStatus: String, Codable, CaseIterable {
    case todos = "Todos"
    case enRevision = "En revisión"
    case fraude = "Fraude"
    case noFraude = "No es fraude"
    
    var colorTexto: Color {
        switch self {
        case .todos:
            return .white
        case .enRevision:
            return Color("ReviewColor")
        case .fraude:
            return Color.red
        case .noFraude:
            return Color("VerificateColor")
        }
    }
    
    var colorFondo: Color {
        switch self {
        case .todos:
            return Color.red
        case .enRevision:
            return Color.orange.opacity(0.15)
        case .fraude:
            return Color.red.opacity(0.12)
        case .noFraude:
            return Color.green.opacity(0.12)
        }
    }
}

// MARK: - VISTAS
struct MyReportsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vm: ReportesViewModel
    @State private var filtroSeleccionado: ReportStatus = .todos
    @State private var reporteAEditar: DTOReporteResponse?
    @State private var reporteAEliminar: DTOReporteResponse?

    private func dto(de reporte: UserReport) -> DTOReporteResponse? {
        // Comparación directa de String UUID
        vm.mios.first { $0.id == reporte.id }
    }
    
    private var reportes: [UserReport] {
        vm.mios.map {
            UserReport(dto: $0, plataforma: vm.nombreFuente($0.fuenteId))
        }
    }
    
    private var perdidas: String {
        let confirmados = vm.mios.filter { $0.estadoId == 2 }
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
                            ReportRowCard(
                                reporte: reporte,
                                onEditar: { reporteAEditar = dto(de: reporte) },
                                onEliminar: { reporteAEliminar = dto(de: reporte) }
                            )
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
        .sheet(item: $reporteAEditar) { reporte in
            // PATCH /reportes/:id
            EditReportView(reporte: reporte)
                .environmentObject(vm)
        }
        .sheet(item: $reporteAEliminar) { reporte in
            // DELETE /reportes/:id con el diseño de DeleteReportView
            DeleteReportView(onDelete: {
                Task { await vm.eliminar(reporte) }
            })
            .presentationDetents([.height(340)])
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
    var onEditar: (() -> Void)? = nil
    var onEliminar: (() -> Void)? = nil
    
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
                        onEditar?()
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
                        onEliminar?()
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
                    Text("Revisado por un administrador. Ya no es editable")
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
