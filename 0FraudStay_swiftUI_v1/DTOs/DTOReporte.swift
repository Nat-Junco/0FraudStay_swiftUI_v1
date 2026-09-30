//
//  DTOReporte.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//

import Foundation

struct DTOReporteResponse: Codable, Identifiable, Hashable {
    let id: Int
    let nombre: String
    let descripcion: String
    let longitud: Double
    let latitud: Double
    let fotoUrl: String
    let precio: Double?
    let zona: String?
    let contactoOfetante: String?
    let usuarioId: String
    let fuenteId: Int
    let estadoId: Int
    let tipoPropiedadId: Int
    let tipoFraudeId: Int
    let createdAt: String
    let updatedAt: String?

    /// URL completa de la foto (el back regresa solo la ruta "/uploads/...").
    var fotoURLCompleta: URL? { URL(string: HTTPClient.baseURL + fotoUrl) }
    /// "2026-09-21T17:00:00.000Z" → "2026-09-21"
    var fecha: String { String(createdAt.prefix(10)) }
    /// Solo Pendiente (1) y En revisión (2) se pueden editar/eliminar.
    var esEditable: Bool { estadoId == 1 || estadoId == 2 }
}


struct DTOCrearReporteRequest: Codable {
    let nombre: String
    let descripcion: String
    let longitud: Double
    let latitud: Double
    let fotoTemp: String
    let fuenteId: Int
    let tipoPropiedadId: Int
    let tipoFraudeId: Int
    let precio: Double?
    let zona: String?
    let contactoOfertante: String?
}


struct DTOActualizarReporteRequest: Codable {
    var nombre: String?
    var descripcion: String?
    var fuenteId: Int?
    var tipoPropiedadId: Int?
    var tipoFraudeId: Int?
}


struct DTOFotoTempResponse: Codable {
    let fotoTemp: String
    let url: String
}


