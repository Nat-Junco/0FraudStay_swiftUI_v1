//
//  LogInView.swift
//  0FraudStay_swiftUI_v1
//

import SwiftUI
struct LogInView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var email = ""
    @State private var password = ""
    @State private var errorLogin: String?
    @State private var cargando = false
    @Environment(\.authController) var controladorRegistro
    
    let primaryColor = Color("BrandPrimaryColor")
    
    private func login() async {
        cargando = true
        errorLogin = nil
        do {
            let exito = try await controladorRegistro.loginUser(email: email, password: password)
            withAnimation {isLoggedIn = exito}
        } catch ErrorAPI.status(401){
            errorLogin = "Correo o password incorrectos"
        } catch ErrorAPI.status(400){
            errorLogin = "Revisa que el correo tenga formato valido"
        } catch {
        errorLogin = "No se pudo actualizar en el servidor"
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
                    Color.white
                        .ignoresSafeArea()
                    VStack(alignment: .leading, spacing: 20) {
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("OFRAUD STAY")
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
                                Text("CORREO / USUARIO")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.gray)
                                TextField("Introduce tu correo o tu usuario", text: $email)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                Text("CONTRASEÑA")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.gray)
                                SecureField("••••••••", text: $password)
                                    .padding()
                                    .background(Color(.systemGray6))
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
                        if let errorLogin{
                            Text(errorLogin)
                                .font(.caption)
                                .foregroundColor(.red)
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
                                    .background(Color(.systemGray6))
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
            }
        }
    }
}

#Preview {
    LogInView()
}
