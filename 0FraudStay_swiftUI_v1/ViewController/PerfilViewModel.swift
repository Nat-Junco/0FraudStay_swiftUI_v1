//
//  PerfilViewModel.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 06/10/26.
//
import Combine
import Foundation

@MainActor
final class PerfilViewModel: ObservableObject {
    @Published var nombre = ""
    @Published var correo = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let controlador = ControladorUsuario(httpClient: HTTPClient())
    
    func cargar() async {
        isLoading = true
        errorMessage = nil
        do {
            let usuario = try await controlador.perfil()
            nombre = usuario.nombre
            correo = usuario.correo
        } catch {
            errorMessage = "No se pudo cargar el perfil. Verifica tu conexión e intenta de nuevo."
        }
        isLoading = false
    }
    
    func guardar(nombre: String, correo: String) async -> Bool {
        errorMessage = nil
        
        if nombre.trimmingCharacters(in: .whitespaces).count < 2 {
            errorMessage = "El nombre debe tener al menos 2 caracteres."
            return false
        }
        
        if !correo.esCorreoValido {
            errorMessage = "Ingresa un correo electrónico válido."
            return false
        }
        
        do {
            let usuario = try await controlador.actualizar(nombre: nombre, correo: correo)
            self.nombre = usuario.nombre
            self.correo = usuario.correo
            return true
        } catch ErrorAPI.status(409) {
            errorMessage = "Este correo electrónico ya está registrado en otra cuenta."
        } catch ErrorAPI.status(400) {
            errorMessage = "Los datos proporcionados no son válidos. Revisa e intenta de nuevo."
        } catch {
            errorMessage = "Ocurrió un error al guardar los cambios. Inténtalo más tarde."
        }
        
        return false
    }
}

