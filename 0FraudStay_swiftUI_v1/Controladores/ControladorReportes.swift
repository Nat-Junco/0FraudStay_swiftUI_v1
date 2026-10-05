//
//  ControladorReportes.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//

import Foundation

struct ControladorReportes {
  let httpClient: HTTPClient

  func catalogos() async throws -> (fuentes:[DTOFuente], tiposFraude: [DTOCatalogo],
  tiposPropiedad:[DTOCatalogo]) {
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
    
    func subirFoto(_ foto: Data) async throws -> String{
        let respuesta = try await httpClient.SubirFoto(foto)
        return respuesta .fotoTemp
    }
     func crear(nombre: String, descripcion: String, latitud: Double, longitud: Double,
               fotoTemp: String, fuenteId: Int, tipoPropiedadId: Int, tipoFraudeId: Int,
                precio: Double?, zona: String?, contactoOfertante: String?
     ) async throws -> DTOReporteResponse {
        let request = DTOCrearReporteRequest(
            nombre: nombre,
            descripcion: descripcion,
            longitud: longitud,
            latitud: latitud,
            fotoTemp: fotoTemp,
            fuenteId: fuenteId,
            tipoPropiedadId: tipoPropiedadId,
            tipoFraudeId: tipoFraudeId,
            precio: precio,
            zona: zona,
            contactoOfertante: contactoOfertante
        )
        return try await httpClient.CrearReporte(request)
    }

    func actualizar(id: Int, cambios: DTOActualizarReporteRequest) async throws -> DTOReporteResponse {
        try await httpClient.ActualizarReporte(id: id, cambios: cambios)
    }

    func eliminar(id: Int) async throws {
        try await httpClient.EliminarReporte(id: id)
    }

}

