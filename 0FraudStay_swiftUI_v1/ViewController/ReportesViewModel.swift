//
//  ReportesViewModel.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 30/09/26.
//

import Foundation

import Combine
import Foundation
import SwiftUI

@MainActor
final class ReportesViewModel: ObservableObject {
    @Published var todos: [DTOReporteResponse] = []
    @Published var mios: [DTOReporteResponse] = []
    @Published var fuentes: [DTOFuente] = []
    @Published var tiposFraude: [DTOCatalogo] = []
    @Published var tiposPropiedad: [DTOCatalogo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let controlador = ControladorReportes(httpClient: HTTPClient())

    func cargarTodo() async {
        isLoading = true
        errorMessage = nil
        do {
            if fuentes.isEmpty {
                let c = try await controlador.catalogos()
                fuentes = c.fuentes
                tiposFraude = c.tiposFraude
                tiposPropiedad = c.tiposPropiedad
            }
            async let t = controlador.todos()
            async let m = controlador.mios()
            (todos, mios) = try await (t, m)
        } catch {
            errorMessage = "No se pudieron cargar los reportes. \(error.localizedDescription)"
        }
        isLoading = false
    }

    func eliminar(_ reporte: DTOReporteResponse) async {
        do {
            try await controlador.eliminar(id: reporte.id)
            mios.removeAll { $0.id == reporte.id }
            todos.removeAll { $0.id == reporte.id }
        } catch {
            errorMessage = "No se pudo eliminar el reporte."
        }
    }

    // MARK: - Traducir ids de catálogo a texto

    func nombreFuente(_ id: Int) -> String {
        fuentes.first { $0.id == id }?.valorFuente ?? "Fuente \(id)"
    }
    func nombreTipoFraude(_ id: Int) -> String {
        tiposFraude.first { $0.id == id }?.nombre ?? "Tipo \(id)"
    }
    func nombreTipoPropiedad(_ id: Int) -> String {
        tiposPropiedad.first { $0.id == id }?.nombre ?? "Propiedad \(id)"
    }

    // MARK: - Métricas
    var totalVerificados: Int { todos.filter { $0.estadoId != 1 }.count }
    var totalFraudes: Int { todos.filter { $0.estadoId == 2 }.count }
    var verificadosRecientes: [DTOReporteResponse] {
        Array(todos.filter { $0.estadoId != 1 }.sorted { $0.createdAt > $1.createdAt }.prefix(3))
    }

}

    // MARK: - Estado → texto, color e ícono
    // 1 = En revisión (amarillo), 2 = Fraude confirmado (rojo), 3 = No es fraude (verde)
    extension DTOReporteResponse {
        var nombreEstado: String {
            switch estadoId {
            case 1: return "EN REVISIÓN"
            case 2: return "FRAUDE"
            case 3: return "NO ES FRAUDE"
            default: return "—"
            }
        }
        var colorEstado: Color {
            switch estadoId {
            case 1: return Color("ReviewColor")
            case 2: return Color("BrandPrimaryColor")
            case 3: return Color("VerificateColor")
            default: return .gray
            }
        }
        var iconoEstado: String {
            switch estadoId {
            case 1: return "clock.fill"
            case 2: return "exclamationmark.triangle.fill"
            case 3: return "checkmark.shield.fill"
            default: return "questionmark.circle.fill"
        }
    }
}


