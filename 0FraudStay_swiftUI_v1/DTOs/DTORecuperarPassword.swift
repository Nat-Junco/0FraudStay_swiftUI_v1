//
//  DTORecuperarPassword.swift
//  0FraudStay_swiftUI_v1
//
//

import Foundation

// MARK: - POST /auth/forgot-password  { correo }
struct DTOOlvideContrasenaRequest: Codable {
    let correo: String
}

// MARK: - POST /auth/reset-password  { correo, codigo, nuevaContrasena }
struct DTORestablecerContrasenaRequest: Codable {
    let correo: String
    let codigo: String
    let nuevaContrasena: String
}

// MARK: - Respuesta de ambos endpoints  { message }
struct DTOMensajeResponse: Codable {
    let message: String
}
