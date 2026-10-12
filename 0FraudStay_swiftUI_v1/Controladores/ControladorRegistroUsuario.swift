//
//  ControladorRegistroUsuario.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//

import Foundation

struct ControladorRegistroUsuario {
    let httpClient: HTTPClient
    
    func registerUser(email: String, password: String, nombre: String) async throws -> DTORegistroUsuarioResponse {
        let response = try await httpClient.RegistroUsuario(email: email, password: password, nombre: nombre)
        return response
    }
    
    func loginUser(email: String, password: String) async throws -> Bool {
        let loginResponse = try await httpClient.Login(email: email, password: password)
        TokenStorage.set(identifier: "accessToken", value: loginResponse.accessToken)
        TokenStorage.set(identifier: "refreshToken", value: loginResponse.refreshToken)
        return !loginResponse.accessToken.isEmpty
    }
    
    func logout() {
        TokenStorage.delete(identifier: "accessToken")
        TokenStorage.delete(identifier: "refreshToken")
    }
    
    // Paso 1: Pide al back que genere y envíe el código al correo (POST /auth/forgot-password)
    func solicitarCodigo(correo: String) async throws {
        _ = try await httpClient.OlvideContrasena(correo: correo)
    }
    
    // Paso 2: Revisa que el código sea correcto y vigente (POST /auth/verify-code)
    func verificarCodigo(correo: String, codigo: String) async throws {
        _ = try await httpClient.VerificarCodigo(correo: correo, codigo: codigo)
    }
    
    // Cambia la contraseña con el código verificada
    func restablecerContrasena(correo: String, codigo: String, nuevaContrasena: String) async throws {
        let respuesta = try await httpClient.RestablecerContrasena(
            correo: correo,
            codigo: codigo,
            nuevaContrasena: nuevaContrasena
        )
        print("✅ Respuesta del servidor: \(respuesta.message)")
    }
}
