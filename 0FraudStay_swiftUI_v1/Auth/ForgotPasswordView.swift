//
//  ForgotPasswordView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 25/09/26.
//
//  Recuperar contraseña en 3 pantallas, conectadas al back:
//  1. ForgotPasswordView  → POST /auth/forgot-password { correo }
//                           (el back genera un código de 6 caracteres y lo manda por correo)
//  2. EnterTokenView      → POST /auth/verify-code { correo, codigo }
//                           Verifica que el código sea correcto y no haya expirado.
//                           "Volver a enviar" repite el paso 1.
//  3. ResetPasswordView   → POST /auth/reset-password { correo, codigo, nuevaContrasena }
//                           Si sale bien, regresa al Login.
//

import SwiftUI


// MARK: - Paso 1: correo
struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.authController) var controladorRegistro

    @State private var email = ""
    @State private var enviando = false
    @State private var errorMsg: String?
    @State private var mostrarAlertaError = false
    @State private var irAToken = false

    private let primaryColor = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")

    private func enviarCodigo() async {
        errorMsg = nil
        let correo = email.trimmingCharacters(in: .whitespaces).lowercased()
        
        if correo.isEmpty {
            errorMsg = "Por favor, ingresa tu correo electrónico."
            mostrarAlertaError = true
            return
        }
        if !correo.esCorreoValido {
            errorMsg = "Ingresa un correo electrónico válido."
            mostrarAlertaError = true
            return
        }

        enviando = true
        do {
            try await controladorRegistro.solicitarCodigo(correo: correo)
            email = correo
            irAToken = true
        } catch ErrorAPI.status(401) {
            errorMsg = "No encontramos una cuenta registrada con ese correo."
            mostrarAlertaError = true
        } catch ErrorAPI.status(500) {
            errorMsg = "No se pudo enviar el correo. Inténtalo más tarde."
            mostrarAlertaError = true
        } catch {
            errorMsg = "Ocurrió un error al conectar con el servidor."
            mostrarAlertaError = true
        }
        enviando = false
    }

    var body: some View {
        ZStack {
            fondo
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 6) {
                    Text("0FRAUD STAY")
                        .font(.caption)
                        .bold()
                        .foregroundColor(primaryColor)
                        .tracking(1)
                    Text("Recuperar contraseña")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                    Text("Ingresa tu correo electrónico y te enviaremos un código para restablecer tu contraseña.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 16)

                VStack(alignment: .leading, spacing: 6) {
                    Text("CORREO ELECTRÓNICO")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.gray)
                    TextField("Ingresa tu correo electrónico", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(12)
                }

                Spacer()

                Button(action: {
                    Task { await enviarCodigo() }
                }) {
                    Text(enviando ? "Enviando…" : "Enviar código")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryColor)
                        .cornerRadius(12)
                }
                .disabled(enviando)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 24)
        }
        .tint(primaryColor)
        .navigationTitle("Recuperar")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $irAToken) {
            EnterTokenView(correo: email, onTerminado: {
                irAToken = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { dismiss() }
            })
        }
        .alert("Aviso", isPresented: $mostrarAlertaError) {
            Button("Aceptar", role: .cancel) {
                 // Vacío a propósito: el rol .cancel cierra la alerta automáticamente
            }
        } message: {
            Text(errorMsg ?? "Revisa los datos e intenta de nuevo.")
        }
        .contentShape(Rectangle())
        .onTapGesture {
        ocultarTeclado()
        }
    }
}

// MARK: - Paso 2: código (Verificación contra la API)
struct EnterTokenView: View {
    @Environment(\.authController) var controladorRegistro

    let correo: String
    var onTerminado: () -> Void = {
      // Por defecto no hace nada; la vista padre puede asignar una acción  
    }

    @State private var token = ""
    @State private var errorMsg: String?
    @State private var mostrarAlertaError = false
    @State private var aviso: String?
    @State private var reenviando = false
    @State private var verificando = false
    @State private var irAReset = false

    private let primaryColor = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")
    private let alfabeto = "ABCDEFGHJKMNPQRSTUVWXYZ23456789"

    private func verificar() async {
        errorMsg = nil
        aviso = nil
        
        guard token.count == 6 else {
            errorMsg = "El código de verificación debe tener exactamente 6 caracteres."
            mostrarAlertaError = true
            return
        }
        
        verificando = true
        do {
            try await controladorRegistro.verificarCodigo(correo: correo, codigo: token)
            irAReset = true
        } catch ErrorAPI.status(401) {
            errorMsg = "El código es incorrecto, ya expiró o fue reemplazado por uno nuevo."
            mostrarAlertaError = true
        } catch {
            errorMsg = "No se pudo conectar con el servidor. Inténtalo más tarde."
            mostrarAlertaError = true
        }
        verificando = false
    }

    private func reenviar() async {
        errorMsg = nil
        aviso = nil
        reenviando = true
        do {
            // CORRECCIÓN: Llamar a solicitarCodigo para generar y enviar un token nuevo
            try await controladorRegistro.solicitarCodigo(correo: correo)
            aviso = "Te enviamos un código nuevo a \(correo)"
            token = "" // Se limpia el campo para que el usuario escriba el nuevo código
        } catch {
            errorMsg = "No se pudo reenviar el código en este momento."
            mostrarAlertaError = true
        }
        reenviando = false
    }

    var body: some View {
        ZStack {
            fondo
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 6) {
                    Text("0FRAUD STAY")
                        .font(.caption)
                        .bold()
                        .foregroundColor(primaryColor)
                        .tracking(1)
                    Text("Ingresar token")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                    Text("Ingresa el código de verificación que enviamos a \(correo). Vence en 15 minutos.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 16)

                VStack(alignment: .leading, spacing: 6) {
                    Text("TOKEN DE VERIFICACIÓN")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.gray)
                    
                    TextField("Ej. K7M2QX", text: $token)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(12)
                        .onChange(of: token) { _, nuevo in
                            let filtrado = String(nuevo.uppercased().filter { alfabeto.contains($0) }.prefix(6))
                            if filtrado != nuevo { token = filtrado }
                        }
                }

                if let aviso {
                    Text(aviso)
                        .font(.caption)
                        .foregroundColor(.green)
                }

                Button(action: {
                    Task { await reenviar() }
                }) {
                    Text(reenviando ? "Reenviando…" : "¿No te llegó el token? Volver a enviar")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(primaryColor)
                }
                .disabled(reenviando || verificando)

                Spacer()

                Button(action: {
                    Task { await verificar() }
                }) {
                    Text(verificando ? "Verificando…" : "Verificar token")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryColor)
                        .cornerRadius(12)
                }
                .disabled(verificando)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("Verificación")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $irAReset) {
            ResetPasswordView(correo: correo, codigo: token, onTerminado: onTerminado)
        }
        .alert("Aviso", isPresented: $mostrarAlertaError) {
            Button("Aceptar", role: .cancel) { 
             // Vacío a propósito: el rol .cancel cierra la alerta automáticamente
            }
        } message: {
            Text(errorMsg ?? "Ingresa un código válido.")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            ocultarTeclado()
        }
    }
}

// MARK: - Paso 3: nueva contraseña
struct ResetPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.authController) var controladorRegistro
    @State private var mostrarNewPassword = false
    @State private var mostrarConfirmPassword = false

    private enum CampoPasswordReset {
        case newPassword
        case confirmPassword
    }

    @FocusState private var campoEnfocado: CampoPasswordReset?

    let correo: String
    let codigo: String
    var onTerminado: () -> Void = {
        // Por defecto no hace nada; la vista padre puede asignar una acción 
    }

    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    // MARK: - Estados de error para cada campo
    @State private var errorNewPassword: String? = nil
    @State private var errorConfirmacion: String? = nil
    @State private var errorDeRed: String?
    @State private var mostrarAlertaError = false
    @State private var guardando = false
    @State private var exito = false

    private let primaryColor = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")

    // MARK: - Validación Individual
    private func validarFormulario() -> Bool {
        errorNewPassword = nil
        errorConfirmacion = nil
        var esValido = true

        // 1. Reglas de la nueva contraseña
        if newPassword.isEmpty {
            errorNewPassword = "Por favor, ingresa tu nueva contraseña."
            esValido = false
        } else if !newPassword.esLongitudValida {
            errorNewPassword = "La contraseña debe tener al menos 10 caracteres."
            esValido = false
        } else if !newPassword.tieneMayuscula {
            errorNewPassword = "La contraseña debe contener al menos una mayúscula."
            esValido = false
        } else if !newPassword.tieneMinuscula {
            errorNewPassword = "La contraseña debe contener al menos una minúscula."
            esValido = false
        } else if !newPassword.tieneNumero {
            errorNewPassword = "La contraseña debe contener al menos un número."
            esValido = false
        } else if !newPassword.tieneSimbolo {
            errorNewPassword = "La contraseña debe contener al menos un símbolo especial."
            esValido = false
        } else if newPassword.tieneTresIgualesSeguidos {
            errorNewPassword = "La contraseña no puede tener tres caracteres iguales consecutivos."
            esValido = false
        }

        // 2. Confirmación de contraseña
        if confirmPassword.isEmpty {
            errorConfirmacion = "La confirmación de la contraseña es requerida."
            esValido = false
        } else if newPassword != confirmPassword {
            errorConfirmacion = "Las contraseñas no coinciden, vuelve a intentarlo."
            esValido = false
        }

        return esValido
    }

    private func confirmar() async {
        guard validarFormulario() else { return }

        guardando = true
        defer { guardando = false }

        do {
            try await controladorRegistro.restablecerContrasena(
                correo: correo,
                codigo: codigo,
                nuevaContrasena: newPassword
            )
            exito = true
        } catch ErrorAPI.status(401) {
            errorDeRed = "El código de verificación es incorrecto o ya expiró (15 min). Solicita uno nuevo."
            mostrarAlertaError = true
        } catch ErrorAPI.status(400) {
            errorDeRed = "La contraseña no cumple con los requisitos de seguridad."
            mostrarAlertaError = true
        } catch {
            print("[ERROR] Fallo al restablecer contraseña: \(error)")
            if let apiError = error as? ErrorAPI {
                print("[ERROR] Estado HTTP: \(apiError)")
            }
            errorDeRed = "No se pudo conectar con el servidor. Inténtalo más tarde."
            mostrarAlertaError = true
        }
    }

    var body: some View {
        ZStack {
            fondo
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 6) {
                    Text("0FRAUD STAY")
                        .font(.caption)
                        .bold()
                        .foregroundColor(primaryColor)
                        .tracking(1)
                    Text("Restablecer contraseña")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                    Text("Crea una nueva contraseña para tu cuenta.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 16)

                VStack(alignment: .leading, spacing: 16) {
                    
                    // Nueva Contraseña
                    VStack(alignment: .leading, spacing: 6) {
                        Text("NUEVA CONTRASEÑA")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        
                        HStack {
                            ZStack {
                                if mostrarNewPassword {
                                    TextField("Mín. 10 caracteres, mayúscula, número y símbolo", text: $newPassword)
                                        .foregroundColor(.black)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                        .focused($campoEnfocado, equals: .newPassword)
                                } else {
                                    SecureField("Mín. 10 caracteres, mayúscula, número y símbolo", text: $newPassword)
                                        .foregroundColor(.black)
                                        .focused($campoEnfocado, equals: .newPassword)
                                }
                            }
                            
                            Button {
                                mostrarNewPassword.toggle()
                                campoEnfocado = .newPassword
                            } label: {
                                Image(systemName: mostrarNewPassword ? "eye.slash.fill" : "eye.fill")
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
                                .stroke(errorNewPassword != nil ? Color.red : Color.clear, lineWidth: 1)
                        )
                        
                        if let msg = errorNewPassword {
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
                            ZStack {
                                if mostrarConfirmPassword {
                                    TextField("Confirma tu nueva contraseña", text: $confirmPassword)
                                        .foregroundColor(.black)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                        .focused($campoEnfocado, equals: .confirmPassword)
                                } else {
                                    SecureField("Confirma tu nueva contraseña", text: $confirmPassword)
                                        .foregroundColor(.black)
                                        .focused($campoEnfocado, equals: .confirmPassword)
                                }
                            }
                            
                            Button {
                                mostrarConfirmPassword.toggle()
                                campoEnfocado = .confirmPassword
                            } label: {
                                Image(systemName: mostrarConfirmPassword ? "eye.slash.fill" : "eye.fill")
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
                                .stroke(errorConfirmacion != nil ? Color.red : Color.clear, lineWidth: 1)
                        )
                        
                        if let msg = errorConfirmacion {
                            Text(msg)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.leading, 4)
                        }
                    }
                }

                Spacer()

                Button(action: {
                    Task { await confirmar() }
                }) {
                    Text(guardando ? "Guardando…" : "Confirmar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryColor)
                        .cornerRadius(12)
                }
                .disabled(guardando)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("Nueva contraseña")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Contraseña actualizada", isPresented: $exito) {
            Button("Iniciar sesión") { onTerminado() }
        } message: {
            Text("Ya puedes entrar con tu nueva contraseña.")
        }
        .alert("Error", isPresented: $mostrarAlertaError) {
            Button("Aceptar", role: .cancel) {
                // Vacío a propósito: el rol .cancel cierra la alerta automáticamente
            }
        } message: {
            Text(errorDeRed ?? "Ocurrió un error inesperado.")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            campoEnfocado = nil
            ocultarTeclado()
        }
    }
}
