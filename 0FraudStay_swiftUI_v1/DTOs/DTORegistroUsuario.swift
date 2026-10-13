//  DTORegistroUsuario.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//

import Foundation


class DTORegistroUsuarioRequest: Codable {
    var email, password, nombre: String

    init(email: String, password: String, nombre: String) {
        self.email = email
        self.password = password
        self.nombre = nombre
    }
}


class DTORegistroUsuarioResponse: Codable {
    var id, email: String

    init(id: String, email: String) {
        self.id = id
        self.email = email
    }
}


