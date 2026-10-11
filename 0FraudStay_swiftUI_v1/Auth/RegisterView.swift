//
//  RegisterView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.authController) var controladorRegistro
    @Environment(\.dismiss) private var dismiss
    @State private var usuario = Usuario()
    
    @State private var nombreError: String?
    @State private var correoError: String?
    @State private var passwordError: String?
    @State private var confirmarPasswordError: String?
    
    //@State private var erroresFormulario: [String] = []
    //@State private var registroExitoso = false
    @State private var irATerminos = false
    @State private var mostrarAlertaExito = false
    @State private var cargando = false
    @State private var errorServidor: String?
    
    private let primaryColor = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")
    
    func registroUsuario() async {
        nombreError = nil
        correoError = nil
        passwordError = nil
        confirmarPasswordError = nil
        errorServidor = nil
        
        var emptySpaces = false
        
        if usuario.nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            nombreError = "Por favor, ingresa tu nombre."
            emptySpaces = true
        }
        if usuario.correo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            correoError = "Por favor, ingresa tu correo electrónico."
            emptySpaces = true
        }
        if usuario.password.isEmpty {
            passwordError = "Por favor, ingresa una contraseña válida."
            emptySpaces = true
        }
        if usuario.confirmarPassword.isEmpty {
            confirmarPasswordError = "La confirmación de la contraseña es requerida."
            emptySpaces = true
        }
        
        if emptySpaces {
            return
        }
        
        cargando = true
        do {
            let response = try await controladorRegistro.registerUser(
                email: usuario.correo,
                password: usuario.password,
                nombre: usuario.nombre
            )
            print("Usuario registrado \(response.id) \(response.email)")
            irATerminos = true
        } catch ErrorAPI.status(409) {
            correoError = "Este correo electrónico ya está asociado a una cuenta. Puedes iniciar sesión, restablecer tu contraseña o intentar con otro correo."
        } catch ErrorAPI.status(400) {
            passwordError = "Las contraseñas no coinciden, vuelve a intentarlo."
        } catch {
            errorServidor = "No se pudo conectar con el servidor. Por favor, verifica tu conexión a internet o inténtalo más tarde."
            Task {
                try? await Task.sleep(for: .seconds(4))
                withAnimation { errorServidor = nil }
            }
            print("Error al registrar \(error)")
        }
        cargando = false
    }
    
    var body: some View {
        ZStack {
            fondo
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Crea tu cuenta")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                        Text("La comunidad necesita tu voz para detener fraudes")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 16)
                    // Name
                    VStack(alignment: .leading, spacing: 14) {
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("NOMBRE COMPLETO")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                            TextField("Introduce tu nombre completo", text: $usuario.nombre)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
                            if let nombreError {
                                Text(nombreError)
                                    .font(.caption2)
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }
                        // Email
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CORREO ELECTRÓNICO")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                            TextField("Introduce tu correo", text: $usuario.correo)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
                            
                            if let correoError {
                                Text(correoError)
                                    .font(.caption2)
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }
                        // Password
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CONTRASEÑA")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                            SecureField("Introduce tu contraseña (mín. 10 caracteres)", text: $usuario.password)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
                            if let passwordError {
                                Text(passwordError)
                                    .font(.caption2)
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CONFIRMAR CONTRASEÑA")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                            SecureField("Introduce tu contraseña", text: $usuario.confirmarPassword)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
                            if let confirmarPasswordError {
                                Text(confirmarPasswordError)
                                    .font(.caption2)
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }
                    }
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await registroUsuario()
                        }
                    }) {
                        Text(cargando ? "Registrando..." : "Registrarme")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor)
                            .cornerRadius(12)
                    }
                    .disabled(cargando)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 24)
                    .tint(primaryColor)
                }
                .padding(.horizontal, 24)
            }
            
            if let errorServidor {
                VStack {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.white)
                        Text(errorServidor)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .bold()
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.red.opacity(0.9))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut, value: errorServidor)
            }
        }
        .navigationDestination(isPresented: $irATerminos) {
                    TerminosView(onAccept: {
                        mostrarAlertaExito = true
                    })
                }
                .alert("¡Cuenta creada!", isPresented: $mostrarAlertaExito) {
                    Button("Iniciar Sesión") {
                        dismiss()
                    }
                } message: {
                    Text("Ya puedes entrar con tu correo y contraseña.")
                }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}

