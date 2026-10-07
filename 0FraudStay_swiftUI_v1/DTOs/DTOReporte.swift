//
//  DTOReporte.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//
//  Espejo de los DTOs de reportes del back (reportes/dto/*.ts).
//  El back responde en camelCase, igual que estas propiedades,
//  así que NO lleva CodingKeys.
//

import Foundation

// MARK: - ReporteResponseDto (GET /reportes, /reportes/self, /reportes/:id)
struct DTOReporteResponse: Codable, Identifiable, Hashable {
    let id: Int
    let nombre: String
    let descripcion: String
    let longitud: Double
    let latitud: Double
    let portada: String
    let evidencia: String
    let precio: Double?
    let zona: String?
    let contactoOfertante: String?
    let usuarioId: String
    let fuenteId: Int
    let estadoId: Int
    let tipoPropiedadId: Int
    let tipoFraudeId: Int
    let createdAt: String
    let updatedAt: String?
    //let colorEstado: Color
    //let iconoEstado: String

    /// URL completa de la portada (el back regresa solo "/uploads/...").
    /// Se mantiene el nombre `fotoURLCompleta` para que las vistas no cambien.
    var fotoURLCompleta: URL? { URL(string: HTTPClient.baseURL + portada) }

    /// URL completa de la foto de evidencia.
    var evidenciaURLCompleta: URL? { URL(string: HTTPClient.baseURL + evidencia) }

    /// "2026-09-21T17:00:00.000Z" → "2026-09-21"
    var fecha: String { String(createdAt.prefix(10)) }

    /// Solo "En revisión" (1) se puede editar/eliminar; ya revisado queda bloqueado
    var esEditable: Bool { estadoId == 1 }

    /// Precio con formato de moneda: "$4,200.00 MXN" o "Sin monto registrado"
    var precioTexto: String {
        guard let precio else { return "Sin monto registrado" }
        let formato = NumberFormatter()
        formato.numberStyle = .currency
        formato.locale = Locale(identifier: "es_MX")
        return (formato.string(from: NSNumber(value: precio)) ?? "$\(precio)") + " MXN"
    }

    /// Folio legible: "RS-0012"
    var folio: String { "RS-\(String(format: "%04d", id))" }
}

// MARK: - CreateReporteDto (POST /reportes)
struct DTOCrearReporteRequest: Codable {
    let nombre: String
    let descripcion: String
    let longitud: Double
    let latitud: Double
    let fotoTemps: [String]          // [portada, evidencia] — el orden importa
    let fuenteId: Int
    let tipoPropiedadId: Int
    let tipoFraudeId: Int
    // Opcionales: si son nil, JSONEncoder no los manda
    let precio: Double?
    let zona: String?
    let contactoOfertante: String?
}

// MARK: - UpdateReporteDto (PATCH /reportes/:id) — todo opcional.
// JSONEncoder omite los nil, así que solo se manda lo que cambió.
struct DTOActualizarReporteRequest: Codable {
    var nombre: String?
    var descripcion: String?
    var fuenteId: Int?
    var tipoPropiedadId: Int?
    var tipoFraudeId: Int?
    var precio: Double?
    var zona: String?
    var contactoOfertante: String?
}

// MARK: - FotoTempResponseDto (POST /reportes/fotos → arreglo de 2)
struct DTOFotoTempResponse: Codable {
    let fotoTemp: String
    let url: String
}
