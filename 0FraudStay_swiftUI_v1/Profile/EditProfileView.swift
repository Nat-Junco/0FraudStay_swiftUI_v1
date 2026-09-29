//
//  EditProfileView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 29/09/26.
//

import SwiftUI
struct profileView: View {
    
    // Colores obtenidos directamente de los Assets
    private let rojoPrimary = Color("BrandPrimaryColor")
    private let verdeVerificate = Color("VerificateColor")
    private let fondo = Color("AppFondo")
    private let fondoTarjeta = Color(.white)
    private let textoPrincipal = Color(.label)
    private let textoGris = Color(.secondaryLabel)
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    VStack(spacing: 12) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(rojoPrimary.opacity(0.8))
                                .background(Circle().fill(rojoPrimary.opacity(0.1)))
                                .clipShape(Circle())
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(rojoPrimary)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(fondoTarjeta, lineWidth: 2)
                                )
                        }
                        
                        Text("Cambiar foto de perfil")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(rojoPrimary)
                    }
                    .padding(.top, 12)
                }}}}}
