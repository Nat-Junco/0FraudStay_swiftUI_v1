//
//  ControladorReportes.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//
//  Intermediario entre las vistas y el HTTPClient (mismo patrón que
//  ControladorRegistroUsuario): las vistas no llaman al HTTPClient directo.
//

import Foundation

struct ControladorReportes {
    let httpClient: HTTPClient

    func catalogos() async throws -> (fuentes: [DTOFuente], tiposFraude: [DTOCatalogo],
                                      tiposPropiedad: [DTOCatalogo]) {
        async let f = httpClient.Fuentes()
        async let tf = httpClient.TiposFraude()
        async let tp = httpClient.TiposPropiedad()
        return try await (f, tf, tp)
    }

    func todos() async throws -> [DTOReporteResponse] {
        try await httpClient.TodosReportes()
    }

    func mios() async throws -> [DTOReporteResponse] {
        try await httpClient.MisReportes()
    }

    /// Paso 1: POST /reportes/fotos con las 2 fotos → [fotoTempPortada, fotoTempEvidencia]
    func subirFotos(portada: Data, evidencia: Data) async throws -> [String] {
        let respuesta = try await httpClient.SubirFotos(portada: portada, evidencia: evidencia)
        return respuesta.map { $0.fotoTemp }
    }

    /// POST /reportes con los fotoTemps del paso 1
    func crear(nombre: String, descripcion: String, latitud: Double, longitud: Double,
               fotoTemps: [String], fuenteId: Int, tipoPropiedadId: Int, tipoFraudeId: Int,
               precio: Double?, zona: String?, contactoOfertante: String?) async throws -> DTOReporteResponse {
        let request = DTOCrearReporteRequest(
            nombre: nombre,
            descripcion: descripcion,
            longitud: longitud,
            latitud: latitud,
            fotoTemps: fotoTemps,
            fuenteId: fuenteId,
            tipoPropiedadId: tipoPropiedadId,
            tipoFraudeId: tipoFraudeId,
            precio: precio,
            zona: zona,
            contactoOfertante: contactoOfertante
        )
        return try await httpClient.CrearReporte(request)
    }

    func actualizar(id: String, cambios: DTOActualizarReporteRequest) async throws -> DTOReporteResponse {
        try await httpClient.ActualizarReporte(id: id, cambios: cambios)
    }

    func eliminar(id: String) async throws {
        try await httpClient.EliminarReporte(id: id)
    }
}
