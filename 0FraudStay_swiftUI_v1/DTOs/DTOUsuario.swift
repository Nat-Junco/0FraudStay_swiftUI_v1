//
//  DTOUsuarioResponse.swift
//  0FraudStay_swiftUI_v1
//
//  Created by Javier Padilla Marcial on 05/10/26.
//


//
//  DTOUsuario.swift
//  0FraudStay_swiftUI_v1
//
//  Espejo de UsuarioResponseDto y UpdateUsuarioDto del back
//  (usuarios/dto/*.ts). Se usa en la pantalla de Perfil.
//

import Foundation

// MARK: - UsuarioResponseDto (GET /usuarios/:id, PATCH /usuarios/:id)
struct DTOUsuarioResponse: Codable {
    let id: String
    let correo: String
    let nombre: String
    let rolId: Int
    let createdAt: String
}

// MARK: - UpdateUsuarioDto (PATCH /usuarios/:id) — solo lo que el usuario puede cambiar.
// JSONEncoder omite los nil, así que solo se manda lo que cambió.
struct DTOActualizarUsuarioRequest: Codable {
    var nombre: String?
    var correo: String?
}
