//
//  RegisterView.swift
//  0FraudStay_swiftUI_v1
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.authController) var controladorRegistro
    @Environment(\.dismiss) private var dismiss
    @State private var usuario = Usuario()
    // Estados para mensajes de error debajo de cada campo
    @State private var errorNombre: String? = nil
    @State private var errorCorreo: String? = nil
    @State private var errorPassword: String? = nil
    @State private var errorConfirmarPassword: String? = nil
    
    @State private var irATerminos = false
    @State private var mostrarAlertaExito = false
    @State private var cargando = false
    @State private var mostrarPassword = false
    @State private var mostrarConfirmarPassword = false
    
    private enum CampoFormulario {
        case nombre
        case correo
        case password
        case confirmarPassword
    }

    @FocusState private var campoEnfocado: CampoFormulario?
    
    private let primaryColor = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")
    
    // Función de validación de campos con mensajes específicos
    private func validarFormulario() -> Bool {
        errorNombre = nil
        errorCorreo = nil
        errorPassword = nil
        errorConfirmarPassword = nil
        var esValido = true
        
        // 1. Nombre
        if usuario.nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorNombre = "Por favor, ingresa tu nombre completo."
            esValido = false
        }
        
        // 2. Correo Electrónico
        let correoLimpio = usuario.correo.trimmingCharacters(in: .whitespacesAndNewlines)
        if correoLimpio.isEmpty {
            errorCorreo = "Por favor, ingresa tu correo electrónico."
            esValido = false
        } else if !correoLimpio.contains("@") || !correoLimpio.contains(".") {
            errorCorreo = "Ingresa una dirección de correo válida."
            esValido = false
        }
        
        // 3. Reglas detalladas de Contraseña
        if usuario.password.isEmpty {
            errorPassword = "Por favor, ingresa tu contraseña."
            esValido = false
        } else if !usuario.password.esLongitudValida {
            errorPassword = "La contraseña debe tener al menos 10 caracteres."
            esValido = false
        } else if !usuario.password.tieneMayuscula {
            errorPassword = "La contraseña debe contener al menos una letra mayúscula."
            esValido = false
        } else if !usuario.password.tieneMinuscula {
            errorPassword = "La contraseña debe contener al menos una letra minúscula."
            esValido = false
        } else if !usuario.password.tieneNumero {
            errorPassword = "La contraseña debe contener al menos un número."
            esValido = false
        } else if !usuario.password.tieneSimbolo {
            errorPassword = "La contraseña debe contener al menos un símbolo especial."
            esValido = false
        } else if usuario.password.tieneTresIgualesSeguidos {
            errorPassword = "La contraseña no puede tener tres caracteres iguales consecutivos."
            esValido = false
        }
        
        // 4. Confirmación de Contraseña
        if usuario.confirmarPassword.isEmpty {
            errorConfirmarPassword = "La confirmación de la contraseña es requerida."
            esValido = false
        } else if usuario.password != usuario.confirmarPassword {
            errorConfirmarPassword = "Las contraseñas no coinciden, vuelve a intentarlo."
            esValido = false
        }
        
        return esValido
    }
    
    func registroUsuario() async {
        guard validarFormulario() else { return }
        
        cargando = true
        do {
            let response = try await controladorRegistro.registerUser(
                email: usuario.correo,
                password: usuario.password,
                nombre: usuario.nombre
            )
            print("Usuario registrado: \(response.id) \(response.email)")
            irATerminos = true
        } catch ErrorAPI.status(409) {
            errorCorreo = "Este correo electrónico ya está asociado a una cuenta."
        } catch ErrorAPI.status(400) {
            errorPassword = "Las contraseñas o datos enviados no son válidos."
        } catch {
            print("Error al registrar: \(error)")
            errorCorreo = "No se pudo conectar con el servidor. Inténtalo más tarde."
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
                    
                    // MARK: - Formulario de Entradas
                    VStack(alignment: .leading, spacing: 14) {
                        
                        // Nombre Completo
                        VStack(alignment: .leading, spacing: 6) {
                            Text("NOMBRE COMPLETO")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                            TextField("Introduce tu nombre completo", text: $usuario.nombre)
                                .focused($campoEnfocado, equals: .nombre)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(errorNombre != nil ? Color.red : Color.clear, lineWidth: 1)
                                )
                            
                            if let msg = errorNombre {
                                Text(msg)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }
                        
                        // Correo Electrónico
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CORREO ELECTRÓNICO")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                            TextField("Introduce tu correo", text: $usuario.correo)
                                .focused($campoEnfocado, equals: .correo)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .foregroundColor(.black)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(errorCorreo != nil ? Color.red : Color.clear, lineWidth: 1)
                                )
                            
                            if let msg = errorCorreo {
                                Text(msg)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }
                        // Contraseña
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CONTRASEÑA")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                            
                            HStack {
                                if mostrarPassword {
                                    TextField("Introduce tu contraseña", text: $usuario.password)
                                        .focused($campoEnfocado, equals: .password) // Vinculación al enum
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                        .foregroundColor(.black)
                                } else {
                                    SecureField("Introduce tu contraseña", text: $usuario.password)
                                        .focused($campoEnfocado, equals: .password) // Vinculación al mismo caso del enum
                                        .foregroundColor(.black)
                                }
                                
                                Button {
                                    mostrarPassword.toggle()
                                    // Al hacer toggle, reasignamos el enum para que el foco no se pierda
                                    campoEnfocado = .password
                                } label: {
                                    Image(systemName: mostrarPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(errorPassword != nil ? Color.red : Color.clear, lineWidth: 1)
                            )
                            
                            if let msg = errorPassword {
                                Text(msg)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }

                        // Confirmar Contraseña
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CONFIRMAR CONTRASEÑA")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                            
                            HStack {
                                Group {
                                    if mostrarConfirmarPassword {
                                        TextField("Introduce tu contraseña", text: $usuario.confirmarPassword)
                                    } else {
                                        SecureField("Introduce tu contraseña", text: $usuario.confirmarPassword)
                                    }
                                }
                                .focused($campoEnfocado, equals: .confirmarPassword)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .foregroundColor(.black)
                                
                                Button {
                                    mostrarConfirmarPassword.toggle()
                                } label: {
                                    Image(systemName: mostrarConfirmarPassword ? "eye.slash.fill" : "eye.fill")
                                        .renderingMode(.template)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                }
                            }
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(errorConfirmarPassword != nil ? Color.red : Color.clear, lineWidth: 1)
                            )
                            
                            if let msg = errorConfirmarPassword {
                                Text(msg)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }
                    }
                    
                    Spacer(minLength: 20)
                    
                    // MARK: - Botón de Registro
                    Button(action: {
                        Task {
                            await registroUsuario()
                        }
                    }) {
                        HStack(spacing: 8) {
                            if cargando {
                                ProgressView()
                                    .tint(.white)
                            }
                            Text(cargando ? "Registrando..." : "Registrarme")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryColor)
                        .cornerRadius(12)
                    }
                    .disabled(cargando)
                    .padding(.bottom, 10)
                }
                .padding(.horizontal, 24)
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
