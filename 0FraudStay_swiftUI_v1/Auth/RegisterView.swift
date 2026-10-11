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
    @State private var erroresFormulario: [String] = []
    @State private var registroExitoso = false
    @State private var irATerminos = false
    private let primaryColor = Color("BrandPrimaryColor")
    
    func registroUsuario() async {
        do {
            let response = try await controladorRegistro.registerUser(
                email: usuario.correo,
                password: usuario.password,
                nombre: usuario.nombre
            )
            print("Usuario registrado \(response.id) \(response.email)")
            registroExitoso = true
        } catch ErrorAPI.status(409) {
            erroresFormulario = ["El correo ya está registrado"]
        } catch ErrorAPI.status(400) {
            erroresFormulario = ["El servidor rechazó los datos. Revisa la contraseña."]
        } catch {
            erroresFormulario = ["No se pudo conectar con el servidor"]
            print("Error al registrar \(error)")
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
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
                        TextField("Escribe tu nombre completo", text: $usuario.nombre)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CORREO ELECTRÓNICO")
                            .keyboardType(.emailAddress)
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        TextField("Escribe tu correo", text: $usuario.correo)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CONTRASEÑA")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        SecureField("Mín. 10 caracteres", text: $usuario.password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    if !erroresFormulario.isEmpty {
                        ResumenErrores(errores: erroresFormulario)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CONFIRMAR CONTRASEÑA")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        SecureField("Repite tu contraseña", text: $usuario.confirmarPassword)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                Spacer()
                Button(action: {
                    erroresFormulario = usuario.validarDatos()
                    if erroresFormulario.isEmpty {
                        Task {
                            await registroUsuario()
                        }
                    }
                }) {
                    Text("Registrarme")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryColor)
                        .cornerRadius(12)
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 24)
                .tint(primaryColor)
                
                // Destino de navegación automático al completar el registro
                .navigationDestination(isPresented: $irATerminos) {
                    TermsView()
                }
                .alert("¡Cuenta creada!", isPresented: $registroExitoso) {
                    Button("Iniciar sesión") { dismiss() }
                } message: {
                    Text("Ya puedes entrar con tu correo y contraseña.")
                }
            }
            .padding(.horizontal, 24)
        }
        
        .navigationDestination(isPresented: $irATerminos) {
            TermsView()
        }
        
        .alert("¡Cuenta creada!", isPresented: $registroExitoso) {
            Button("Iniciar sesión") { dismiss() }
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

