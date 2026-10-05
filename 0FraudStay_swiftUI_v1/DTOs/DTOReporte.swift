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
    let fotoUrl: String?
    let usuarioId: String
    let fuenteId: Int
    let estadoId: Int
    let tipoPropiedadId: Int
    let tipoFraudeId: Int
    let createdAt: String
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nombre
        case descripcion
        case longitud
        case latitud
        case fotoUrl = "foto_url"
        case usuarioId = "usuario_id"
        case fuenteId = "fuente_id"
        case estadoId = "estado_id"
        case tipoPropiedadId = "tipo_propiedad_id"
        case tipoFraudeId = "tipo_fraude_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    /// URL completa para cargar la imagen en la app
    var fotoURLCompleta: URL? {
        guard let foto = fotoUrl, !foto.isEmpty else { return nil }
        return URL(string: HTTPClient.baseURL + foto)
    }

    /// "2026-09-21T17:00:00.000Z" → "2026-09-21"
    var fecha: String {
        String(createdAt.prefix(10))
    }

    /// Solo Pendiente (1) y En revisión (2) se pueden editar/eliminar
    var esEditable: Bool {
        estadoId == 1 || estadoId == 2
    }
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


