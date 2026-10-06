//
//  DTOUsuario.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 06/10/26.
//

import Foundation

struct DTOUsuarioResponse: Codable {
    let id: String
    let correo: String
    let nombre: String
    let rolId: Int
    let createdAt: String
}

struct DTOActualizarUsuarioRequest: Codable {
    var nombre: String?
    var correo: String?
    
}
