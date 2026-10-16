//
//  LogInView.swift
//  0FraudStay_swiftUI_v1
//

import SwiftUI

extension View {
    func ocultarTeclado() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct LogInView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    @State private var email = ""
    @State private var password = ""
    @State private var cargando = false
    @State private var mostrarPassword = false
    @FocusState private var estaEnfocado: Bool
    
    // Estados para mensajes de error inline
    @State private var errorEmail: String? = nil
    @State private var errorPassword: String? = nil
    
    @Environment(\.authController) var controladorRegistro
    
    private let primaryColor = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")
    
    // Validación básica para inicio de sesión
    private func validarFormulario() -> Bool {
        errorEmail = nil
        errorPassword = nil
        var esValido = true
        
        let emailLimpio = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if emailLimpio.isEmpty {
            errorEmail = "Por favor, ingresa tu correo electrónico."
            esValido = false
        } else if !emailLimpio.contains("@") || !emailLimpio.contains(".") {
            errorEmail = "Ingresa una dirección de correo válida."
            esValido = false
        }
        
        if password.isEmpty {
            errorPassword = "Por favor, ingresa tu contraseña."
            esValido = false
        }
        
        return esValido
    }
    
    private func login() async {
        guard validarFormulario() else { return }
        
        cargando = true
        errorEmail = nil
        errorPassword = nil
        
        do {
            let exito = try await controladorRegistro.loginUser(email: email, password: password)
            withAnimation { isLoggedIn = exito }
        } catch ErrorAPI.status(401) {
            // Mensaje cuando las credenciales no coinciden con la base de datos
            errorPassword = "La contraseña no coincide."
        } catch ErrorAPI.status(400) {
            errorEmail = "El formato del correo electrónico no es válido."
        } catch {
            print(error.localizedDescription)
            errorEmail = "No se pudo conectar con el servidor. Inténtalo más tarde."
        }
        
        cargando = false
    }
    
    var body: some View {
        if isLoggedIn {
            StartView()
        } else {
            NavigationStack {
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
                            Text("Iniciar sesión")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                            Text("Accede para consultar y registrar denuncias")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 10)
                        
                        // MARK: - Formulario de Entradas
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // Campo: Correo Electrónico
                            VStack(alignment: .leading, spacing: 6) {
                                Text("CORREO ELECTRÓNICO")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.gray)
                                
                                TextField("Introduce tu correo", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(.white))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(errorEmail != nil ? Color.red : Color.clear, lineWidth: 1)
                                    )
                                
                                if let msg = errorEmail {
                                    Text(msg)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .padding(.leading, 4)
                                }
                            }
                            
                            // Campo: Contraseña
                            VStack(alignment: .leading, spacing: 6) {
                                Text("CONTRASEÑA")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    ZStack {
                                        if mostrarPassword {
                                            TextField("••••••••••", text: $password)
                                                .foregroundColor(.black)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled()
                                                .focused($estaEnfocado)
                                        } else {
                                            SecureField("••••••••••", text: $password)
                                                .foregroundColor(.black)
                                                .focused($estaEnfocado)
                                        }
                                    }
                                    
                                    Button {
                                        mostrarPassword.toggle()
                                        estaEnfocado = true
                                    } label: {
                                        Image(systemName: mostrarPassword ? "eye.slash.fill" : "eye.fill")
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
                                        .stroke(errorPassword != nil ? Color.red : Color.clear, lineWidth: 1)
                                )
                                
                                // Muestra "La contraseña no coincide" cuando falla la autenticación
                                if let msg = errorPassword {
                                    Text(msg)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .padding(.leading, 4)
                                }
                            }
                            
                            HStack {
                                Spacer()
                                NavigationLink(destination: ForgotPasswordView()) {
                                    Text("¿Olvidaste tu contraseña?")
                                        .font(.subheadline)
                                        .foregroundColor(primaryColor)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // MARK: - Botones de Acción
                        VStack(spacing: 12) {
                            Button(action: {
                                Task {
                                    await login()
                                }
                            }) {
                                HStack(spacing: 8) {
                                    if cargando {
                                        ProgressView()
                                            .tint(.white)
                                    }
                                    Text(cargando ? "Entrando..." : "Entrar")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(primaryColor)
                                .cornerRadius(14)
                            }
                            .disabled(cargando)
                            
                            NavigationLink(destination: RegisterView()) {
                                Text("¿No tienes cuenta? Regístrate")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(fondo)
                                    .cornerRadius(14)
                            }
                            
                            Text("Tus datos están protegidos conforme a la Ley Federal de Protección de Datos Personales")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
                        }
                        .padding(.bottom, 10)
                    }
                    .padding(.horizontal, 24)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                estaEnfocado = false
                ocultarTeclado()
                }
            }
        }
    }
}

#Preview {
    LogInView()
}
