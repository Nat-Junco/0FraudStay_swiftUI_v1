//
//  RegisterView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Lo que escribe el usuario
    @State private var nombre = ""
    @State private var correo = ""
    @State private var contrasena = ""
    @State private var confirmar = ""
    
    // Reglas para activar tu botón de registrarse
    private var camposLlenos: Bool {
        !nombre.isEmpty && !correo.isEmpty && !contrasena.isEmpty && !confirmar.isEmpty
    }
    private var contrasenaValida: Bool { contrasena.count >= 8 }
    private var contrasenasIguales: Bool { contrasena == confirmar }
    private var puedeContinuar: Bool { camposLlenos && contrasenaValida && contrasenasIguales }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // 1. "← Volver" en rojo
                    Button {
                        dismiss()
                    } label: {
                        Text("← Volver")
                            .font(.system(size: 17))
                            .foregroundStyle(Color("Rojo"))
                    }
                    
                    // 2. Barra de 2 segmentos: el primero en rojo
                    HStack(spacing: 8) {
                        Capsule()
                            .fill(Color("Rojo"))
                            .frame(height: 4)
                        Capsule()
                            .fill(Color("Borde"))
                            .frame(height: 4)
                    }
                    .padding(.bottom, 16)
                    
                    // 3. Títulos
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Crea tu cuenta")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundStyle(Color("TextoPrincipal"))
                        Text("La comunidad necesita tu voz para detener fraudes")
                            .font(.system(size: 16))
                            .foregroundStyle(Color("TextoGris"))
                    }
                    .padding(.bottom, 8)
                    
                    // 4. Nombre completo
                    VStack(alignment: .leading, spacing: 8) {
                        Text("NOMBRE COMPLETO")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color("TextoGris"))
                        TextField("Ana Martínez", text: $nombre)
                            .font(.system(size: 16))
                            .padding(16)
                            .background(Color("Tarjeta"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("Borde")))
                    }
                    
                    // 5. Correo electrónico
                    VStack(alignment: .leading, spacing: 8) {
                        Text("CORREO ELECTRÓNICO")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color("TextoGris"))
                        TextField("ana@correo.com", text: $correo)
                            .font(.system(size: 16))
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(16)
                            .background(Color("Tarjeta"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("Borde")))
                    }
                    
                    // 6. Contraseña (con puntitos)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("CONTRASEÑA")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color("TextoGris"))
                        SecureField("Mín. 8 caracteres", text: $contrasena)
                            .font(.system(size: 16))
                            .padding(16)
                            .background(Color("Tarjeta"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("Borde")))
                    }
                    
                    // 7. Confirmar contraseña
                    VStack(alignment: .leading, spacing: 8) {
                        Text("CONFIRMAR CONTRASEÑA")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color("TextoGris"))
                        SecureField("Repite tu contraseña", text: $confirmar)
                            .font(.system(size: 16))
                            .padding(16)
                            .background(Color("Tarjeta"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("Borde")))
                    }
                    
                    // 8. Avisos de validación
                    if !contrasena.isEmpty && !contrasenaValida {
                        Text("La contraseña debe tener al menos 8 caracteres")
                            .font(.system(size: 13))
                            .foregroundStyle(Color("Rojo"))
                    }
                    if !confirmar.isEmpty && !contrasenasIguales {
                        Text("Las contraseñas no coinciden")
                            .font(.system(size: 13))
                            .foregroundStyle(Color("Rojo"))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
            }
            
            // Botón de registro conectado a las reglas de validación
            Button(action: {
                // Acción al presionar el botón
            }) {
                Text("Registrarme")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
            }
            .disabled(!puedeContinuar)
            .opacity(puedeContinuar ? 1.0 : 0.45)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color("Fondo"))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}

