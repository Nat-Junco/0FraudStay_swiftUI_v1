//
//  LogInView.swift
//  0FraudStay_swiftUI_v1
//

import SwiftUI
struct LogInView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    @State private var email = ""
    @State private var password = ""
    @State private var errorLogin: String?
    @State private var cargando = false
    @State private var errorServidor: String?
    @Environment(\.authController) var controladorRegistro
    
    private let primaryColor = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")
    
    private func login() async {
        cargando = true
        errorLogin = nil
        do {
            let exito = try await controladorRegistro.loginUser(email: email, password: password)
            withAnimation { isLoggedIn = exito }
        } catch ErrorAPI.status(401){
            errorLogin = "El correo o la contraseña ingresados son incorrectos. Por favor, inténtelo de nuevo."
        } catch ErrorAPI.status(400){
            errorLogin = "Por favor, ingresa una dirección de correo electrónico válida."
        } catch {
            errorServidor = "No se pudo conectar con el servidor. Por favor, verifica tu conexión a internet o inténtalo más tarde."
            Task {
                try? await Task.sleep(for: .seconds(4))
                withAnimation { errorServidor = nil }
            }
            print(error.localizedDescription)
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
                        VStack(alignment: .leading, spacing: 16) {
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("CORREO ELECTRÓNICO")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.gray)
                                TextField("Introduce tu correo ", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(.white))
                                    .cornerRadius(12)
                                
                                if let errorLogin, errorLogin.contains("dirección de correo") {
                                    Text(errorLogin)
                                        .font(.caption2)
                                        .foregroundColor(.red)
                                        .padding(.leading, 4)
                                }
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                Text("CONTRASEÑA")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.gray)
                                SecureField("••••••••••", text: $password)
                                    .padding()
                                    .background(Color(.white))
                                    .cornerRadius(12)
                    
                                if let errorLogin, !errorLogin.contains("dirección de correo") {
                                    Text(errorLogin)
                                        .font(.caption2)
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
                        VStack(spacing: 12) {
                            Button(action: {
                                Task {
                                    await login()
                                }
                            }) {
                                Text(cargando ? "Entrando" : "Entrar")
                                    .font(.headline)
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
                                    .background(Color(fondo))
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
            }
        }
    }
}

#Preview {
    LogInView()
}
