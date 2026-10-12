//
//  LogInView.swift
//  0FraudStay_swiftUI_v1
//

import SwiftUI

struct LogInView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    @State private var email = ""
    @State private var password = ""
    @State private var cargando = false
    
    // Arreglo para almacenar los errores y desplegar el banner de alerta
    @State private var erroresFormulario: [String] = []
    
    @Environment(\.authController) var controladorRegistro
    
    private let primaryColor = Color("BrandPrimaryColor")
    private let fondo = Color("FondoApp")
    
    private func login() async {
        cargando = true
        withAnimation { erroresFormulario = [] }
        
        do {
            let exito = try await controladorRegistro.loginUser(email: email, password: password)
            withAnimation { isLoggedIn = exito }
        } catch ErrorAPI.status(401) {
            mostrarErrorConAutoOcultar("El correo o la contraseña ingresados son incorrectos.")
        } catch ErrorAPI.status(400) {
            mostrarErrorConAutoOcultar("Por favor, ingresa una dirección de correo electrónico válida.")
        } catch {
            print(error.localizedDescription)
            mostrarErrorConAutoOcultar("No se pudo conectar con el servidor. Verifica tu conexión a internet o inténtalo más tarde.")
        }
        
        cargando = false
    }

    // Función auxiliar para mostrar el banner y desvanecerlo automáticamente tras 4 segundos
    private func mostrarErrorConAutoOcultar(_ mensaje: String) {
        withAnimation(.easeInOut(duration: 0.3)) {
            erroresFormulario = [mensaje]
        }
        
        Task {
            try? await Task.sleep(for: .seconds(4))
            // Verifica que la alerta siga siendo la misma antes de ocultarla
            if erroresFormulario.contains(mensaje) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    erroresFormulario = []
                }
            }
        }
    }
    
    var body: some View {
        if isLoggedIn {
            StartView()
        } else {
            NavigationStack {
                ZStack(alignment: .top) {
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
                                TextField("Introduce tu correo", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(.white))
                                    .cornerRadius(12)
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
            }
        }
    }
}

#Preview {
    LogInView()
}
