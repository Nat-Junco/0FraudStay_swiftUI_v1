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
            errorMessage = "No se pudo cargar un perfil. "
        }
        isLoading = false
    }
    
    func guardar(nombre: String, correo:String) async ->Bool {
        errorMessage = nil
        if nombre.trimmingCharacters(in: .whitespaces).count < 2{
            errorMessage = "El nombre debe tener al menos 2 caracteres"
            return false
        }
        if !correo.esCorreoValido {
            errorMessage = "Ingresa un correo válido"
            return false
        }
        do {
            let usuario = try await controlador.actualizar(nombre: nombre, correo: correo)
            self.nombre = usuario.nombre
            self.correo = usuario.correo
            return true
        } catch ErrorAPI.status(409){
            errorMessage = "Ese correo ya esta registrado"
        } catch ErrorAPI.status(400){
            errorMessage = "Revisa los datos e intenta de nuevo"
        } catch {
            errorMessage = "No se puedo guardar. \(error.localizedDescription)"
        }
        return false
    }
}

