//
//  HTTPCliente.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//

import Foundation

struct HTTPClient {

    // En el simulador `localhost` apunta a tu Mac. En un iPhone físico
    // cámbialo por la IP de tu Mac, p. ej. "http://192.168.1.20:3000".
    static let baseURL = "http://192.168.100.133:3000"

    //Auth (sin token)

    func RegistroUsuario(email: String, password: String, nombre: String) async throws -> DTORegistroUsuarioResponse {
        let requestForm = DTORegistroUsuarioRequest(email: email, password: password, nombre: nombre)
        var httpRequest = URLRequest(url: url("/auth/register"))
        httpRequest.httpMethod = "POST"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        httpRequest.httpBody = try JSONEncoder().encode(requestForm)
        let (data, response) = try await URLSession.shared.data(for: httpRequest)
        try validarRespuesta(response)
        return try JSONDecoder().decode(DTORegistroUsuarioResponse.self, from: data)
    }

    func Login(email: String, password: String) async throws -> DTOLoginResponse {
        let loginRequest = DTOLoginRequest(email: email, password: password)
        var urlRequest = URLRequest(url: url("/auth/login"))
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(loginRequest)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        try validarRespuesta(response)
        return try JSONDecoder().decode(DTOLoginResponse.self, from: data)
    }
    
    /// POST /auth/verify-code — revisa que el código sea correcto y vigente
    /// SIN cambiar la contraseña. 200 = válido, 401 = inválido o expirado.
    func VerificarCodigo(correo: String, codigo: String) async throws -> DTOMensajeResponse {
        var urlRequest = URLRequest(url: url("/auth/verify-code"))
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(DTOVerificarCodigoRequest(correo: correo, codigo: codigo))
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        try validarRespuesta(response)
        return try JSONDecoder().decode(DTOMensajeResponse.self, from: data)
    }

    func RestablecerContrasena(correo: String, codigo: String, nuevaContrasena: String) async throws -> DTOMensajeResponse {
        let endpointURL = url("/auth/reset-password")
        print("🌐 Enviando POST a: \(endpointURL.absoluteString)") // Imprime la URL completa
        
        var urlRequest = URLRequest(url: endpointURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dto = DTORestablecerContrasenaRequest(correo: correo, codigo: codigo, nuevaContrasena: nuevaContrasena)
        urlRequest.httpBody = try JSONEncoder().encode(dto)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        try validarRespuesta(response)
        return try JSONDecoder().decode(DTOMensajeResponse.self, from: data)
    }
    

    /// POST /auth/refresh — cambia el refreshToken (7 días) por un accessToken nuevo.
    func Refresh() async throws -> Bool {
        guard let refreshToken = TokenStorage.get(identifier: "refreshToken") else { return false }
        var urlRequest = URLRequest(url: url("/auth/refresh"))
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(DTORefreshRequest(refreshToken: refreshToken))
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            return false
        }
        let refresh = try JSONDecoder().decode(DTORefreshResponse.self, from: data)
        TokenStorage.set(identifier: "accessToken", value: refresh.accessToken)
        return true
    }
    
    //Catalogos
    
    func Fuentes() async throws -> [DTOFuente] {
         let data = try await enviarConToken(URLRequest(url: url("/fuentes")))
         return try JSONDecoder().decode([DTOFuente].self, from: data)
     }

     func TiposFraude() async throws -> [DTOCatalogo] {
         let data = try await enviarConToken(URLRequest(url: url("/tipos-fraude")))
         return try JSONDecoder().decode([DTOCatalogo].self, from: data)
     }

     func TiposPropiedad() async throws -> [DTOCatalogo] {
         let data = try await enviarConToken(URLRequest(url: url("/tipos-propiedad")))
         return try JSONDecoder().decode([DTOCatalogo].self, from: data)
     }

     // Reportes

     /// GET /reportes — todos los reportes (de todos los usuarios).
     func TodosReportes() async throws -> [DTOReporteResponse] {
         let data = try await enviarConToken(URLRequest(url: url("/reportes")))
         return try JSONDecoder().decode([DTOReporteResponse].self, from: data)
     }

     /// GET /reportes/self — reportes del usuario autenticado.
     func MisReportes() async throws -> [DTOReporteResponse] {
         let data = try await enviarConToken(URLRequest(url: url("/reportes/self")))
         return try JSONDecoder().decode([DTOReporteResponse].self, from: data)
     }

     /// POST /reportes/fotos — sube portada y evidencia en una sola petición
     /// multipart, las dos en el campo "fotos" (FilesInterceptor('fotos', 2)).
     /// El back regresa un arreglo en el mismo orden: [portada, evidencia].
     func SubirFotos(portada: Data, evidencia: Data) async throws -> [DTOFotoTempResponse] {
         let boundary = "Boundary-\(UUID().uuidString)"
         var urlRequest = URLRequest(url: url("/reportes/fotos"))
         urlRequest.httpMethod = "POST"
         urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

         var body = Data()
         for (nombre, imagen) in [("portada.jpg", portada), ("evidencia.jpg", evidencia)] {
             body.append("--\(boundary)\r\n".data(using: .utf8)!)
             body.append("Content-Disposition: form-data; name=\"fotos\"; filename=\"\(nombre)\"\r\n".data(using: .utf8)!)
             body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
             body.append(imagen)
             body.append("\r\n".data(using: .utf8)!)
         }
         body.append("--\(boundary)--\r\n".data(using: .utf8)!)
         urlRequest.httpBody = body

         let data = try await enviarConToken(urlRequest)
         return try JSONDecoder().decode([DTOFotoTempResponse].self, from: data)
     }

     /// POST /reportes — crea el reporte con los `fotoTemps` de POST /reportes/fotos.
     func CrearReporte(_ reporte: DTOCrearReporteRequest) async throws -> DTOReporteResponse {
         var urlRequest = URLRequest(url: url("/reportes"))
         urlRequest.httpMethod = "POST"
         urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
         urlRequest.httpBody = try JSONEncoder().encode(reporte)
         let data = try await enviarConToken(urlRequest)
         return try JSONDecoder().decode(DTOReporteResponse.self, from: data)
     }

     /// PATCH /reportes/:id
     func ActualizarReporte(id: Int, cambios: DTOActualizarReporteRequest) async throws -> DTOReporteResponse {
         var urlRequest = URLRequest(url: url("/reportes/\(id)"))
         urlRequest.httpMethod = "PATCH"
         urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
         urlRequest.httpBody = try JSONEncoder().encode(cambios)
         let data = try await enviarConToken(urlRequest)
         return try JSONDecoder().decode(DTOReporteResponse.self, from: data)
     }

     /// DELETE /reportes/:id — borrado lógico, responde 204 sin cuerpo.
     func EliminarReporte(id: Int) async throws {
         var urlRequest = URLRequest(url: url("/reportes/\(id)"))
         urlRequest.httpMethod = "DELETE"
         _ = try await enviarConToken(urlRequest)
     }
    
    // Usuarios (Perfil)

    /// GET /usuarios/:id — datos del usuario (nombre, correo, rol).
    func ObtenerUsuario(id: String) async throws -> DTOUsuarioResponse {
        let data = try await enviarConToken(URLRequest(url: url("/usuarios/\(id)")))
        return try JSONDecoder().decode(DTOUsuarioResponse.self, from: data)
    }

    /// PATCH /usuarios/:id — actualiza nombre y/o correo.
    func ActualizarUsuario(id: String, cambios: DTOActualizarUsuarioRequest) async throws -> DTOUsuarioResponse {
        var urlRequest = URLRequest(url: url("/usuarios/\(id)"))
        urlRequest.httpMethod = "PATCH"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(cambios)
        let data = try await enviarConToken(urlRequest)
        return try JSONDecoder().decode(DTOUsuarioResponse.self, from: data)
    }

    //Utilidades

    private func url(_ ruta: String) -> URL {
        guard let url = URL(string: HTTPClient.baseURL + ruta) else {
            fatalError("Invalid URL " + HTTPClient.baseURL + ruta)
        }
        return url
    }

    /// Agrega el Bearer token, manda la petición y, si el back responde 401,
    /// intenta renovar el token UNA vez y reintenta. Si tampoco se puede
    /// renovar, cierra la sesión (isLoggedIn = false → regresa al login).
    private func enviarConToken(_ request: URLRequest, reintentar: Bool = true) async throws -> Data {
        var request = request
        if let token = TokenStorage.get(identifier: "accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, http.statusCode == 401 {
            if reintentar, (try? await Refresh()) == true {
                return try await enviarConToken(request, reintentar: false)
            }
            TokenStorage.delete(identifier: "accessToken")
            TokenStorage.delete(identifier: "refreshToken")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }
        try validarRespuesta(response)
        return data
    }
    
    /// POST /auth/forgot-password — Genera el código y lo envía por correo
    func OlvideContrasena(correo: String) async throws -> DTOMensajeResponse {
        var urlRequest = URLRequest(url: url("/auth/forgot-password"))
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(DTOOlvideContrasenaRequest(correo: correo))
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        try validarRespuesta(response)
        return try JSONDecoder().decode(DTOMensajeResponse.self, from: data)
    }

    /// Si el back responde 4xx/5xx (ej. 401 password incorrecto, 409 correo
    /// duplicado, 400 validación), lanzamos error en vez de intentar
    /// decodificar el JSON de error como si fuera el DTO de éxito.
    private func validarRespuesta(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(http.statusCode) else {
            throw ErrorAPI.status(http.statusCode)
        }
    }
}

enum ErrorAPI: Error {
    case status(Int)
}
