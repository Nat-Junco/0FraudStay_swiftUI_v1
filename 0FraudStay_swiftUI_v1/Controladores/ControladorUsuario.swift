//
//  ControladorUsuario.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 06/10/26.
//  Datos del user para la pantalla de Profile View

import Foundation

struct ControladorUsuario {
    let httpClient: HTTPClient

    func perfil() async throws -> DTOUsuarioResponse {
        return try await httpClient.ObtenerUsuario()
    }

    func actualizar(nombre: String, correo: String) async throws -> DTOUsuarioResponse {
        let cambios = DTOActualizarUsuarioRequest(nombre: nombre, correo: correo)
        return try await httpClient.ActualizarUsuario(cambios: cambios)
    }
}
