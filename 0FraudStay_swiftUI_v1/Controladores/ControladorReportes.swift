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
  tiposPropiedad:[DTOCatalogo]{
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
     func crear(nombre: String, descripcion: String, latitud: Double, longitud: Double,
               foto: Data, fuenteId: Int, tipoPropiedadId: Int, tipoFraudeId: Int) async throws -> DTOReporteResponse {
        let fotoSubida = try await httpClient.SubirFoto(foto)
        let request = DTOCrearReporteRequest(
            nombre: nombre,
            descripcion: descripcion,
            longitud: longitud,
            latitud: latitud,
            fotoTemp: fotoSubida.fotoTemp,
            fuenteId: fuenteId,
            tipoPropiedadId: tipoPropiedadId,
            tipoFraudeId: tipoFraudeId
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

