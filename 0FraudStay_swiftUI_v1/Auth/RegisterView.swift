//
//  RegisterView.swift
//  0FraudStay_swiftUI_v1
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.authController) var controladorRegistro
    @Environment(\.dismiss) private var dismiss
    @State private var usuario = Usuario()
    
    // Arreglo para acumular errores y desplegar el banner flotante superior
    @State private var erroresFormulario: [String] = []
    
    @State private var irATerminos = false
    @State private var mostrarAlertaExito = false
    @State private var cargando = false
    
    private let primaryColor = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")
    
    // Función auxiliar para mostrar errores con animación y desvanecimiento automático
    private func mostrarErrores(_ lista: [String]) {
        withAnimation(.easeInOut(duration: 0.3)) {
            erroresFormulario = lista
        }
        
        Task {
            try? await Task.sleep(for: .seconds(4))
            if erroresFormulario == lista {
                withAnimation(.easeInOut(duration: 0.3)) {
                    erroresFormulario = []
                }
            }
        }
    }
    
    func registroUsuario() async {
        withAnimation { erroresFormulario = [] }
        var validacionesLocales: [String] = []
        
        // 1. Validaciones locales de formulario
        if usuario.nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validacionesLocales.append("Por favor, ingresa tu nombre completo.")
        }
        if usuario.correo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validacionesLocales.append("Por favor, ingresa tu correo electrónico.")
        }
        if usuario.password.isEmpty {
            validacionesLocales.append("Por favor, ingresa una contraseña válida.")
        }
        if usuario.confirmarPassword.isEmpty {
            validacionesLocales.append("La confirmación de la contraseña es requerida.")
        } else if !usuario.password.isEmpty && usuario.password != usuario.confirmarPassword {
            validacionesLocales.append("Las contraseñas no coinciden, vuelve a intentarlo.")
        }
        
        guard validacionesLocales.isEmpty else {
            mostrarErrores(validacionesLocales)
            return
        }
        
        // 2. Petición al servidor
        cargando = true
        do {
            let response = try await controladorRegistro.registerUser(
                email: usuario.correo,
                password: usuario.password,
                nombre: usuario.nombre
            )
            print("Usuario registrado: \(response.id) - \(response.email)")
            irATerminos = true
        } catch ErrorAPI.status(409) {
            mostrarErrores(["Este correo electrónico ya está asociado a una cuenta."])
        } catch ErrorAPI.status(400) {
            mostrarErrores(["Las contraseñas o datos enviados no son válidos. Revisa la información."])
        } catch {
            print("Error al registrar: \(error)")
            mostrarErrores(["No se pudo conectar con el servidor. Verifica tu conexión a internet o inténtalo más tarde."])
        }
        cargando = false
    }
    
    var body: some View {
        ZStack(alignment: .top) {
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
                    
                    // Formulario de Entradas
                    VStack(alignment: .leading, spacing: 14) {
                        
                        // Nombre
                        VStack(alignment: .leading, spacing: 6) {
                            Text("NOMBRE COMPLETO")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                            TextField("Introduce tu nombre completo", text: $usuario.nombre)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
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
                        }
                        
                        // Contraseña
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CONTRASEÑA")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                            SecureField("Introduce tu contraseña (mín. 10 caracteres)", text: $usuario.password)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
                        }
                        
                        // Confirmar Contraseña
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CONFIRMAR CONTRASEÑA")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                            SecureField("Introduce tu contraseña", text: $usuario.confirmarPassword)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
                        }
                    }
                    
                    Spacer(minLength: 20)
                    
                    // Botón de Registro
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
            
            // MARK: - BANNER DE ALERTA DE ERRORES (Mismo estilo que CreateReportView)
            if !erroresFormulario.isEmpty {
                VStack {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Por favor corrige lo siguiente:")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                            
                            ForEach(erroresFormulario, id: \.self) { error in
                                Text("• \(error)")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.95))
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation { erroresFormulario = [] }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    .padding()
                    .background(primaryColor.opacity(0.95))
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: erroresFormulario)
                .zIndex(10)
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
