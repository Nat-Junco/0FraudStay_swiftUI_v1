//
//  ControladorUsuario.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 06/10/26.
//  Datos del user para la pantalla de Profile View

import Foundation

struct ControladorUsuario {
    let httpClient: HTTPClient
    
    func perfil() async throws -> DTOUsuarioResponse{
        guard let id = TokenStorage.usuarioIdDelToken() else {
            throw ErrorAPI.status(401)
        }
        return try await httpClient.ObtenerUsuario(id:id)
    }
    
    func actualizar (nombre: String, correo: String) async throws -> DTOUsuarioResponse{
        guard let id = TokenStorage.usuarioIdDelToken() else {
            throw ErrorAPI.status(401)
        }
        let cambios = DTOActualizarUsuarioRequest (nombre: nombre, correo: correo)
        return try await httpClient.ActualizarUsuario(id: id, cambios: cambios)
    }
}
