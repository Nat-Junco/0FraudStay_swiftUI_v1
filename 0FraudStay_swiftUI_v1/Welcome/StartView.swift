//
//  StartView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import SwiftUI

enum Tab {
    case inicio
    case reportes
    case crear
    case dashboard
    case perfil
}

struct StartView: View {

    // Pestaña seleccionada de la barra de abajo
    @State private var selectedTab: Tab = .inicio

    // Colores de la app
    private let rojo = Color("BrandPrimaryColor")
    private let verde = Color("VerificateColor")
    private let fondo = Color(red: 0.95, green: 0.95, blue: 0.97)
    private let borde = Color(red: 0.90, green: 0.90, blue: 0.92)
    private let textoPrincipal = Color(red: 0.11, green: 0.11, blue: 0.12)
    private let textoGris = Color(red: 0.56, green: 0.56, blue: 0.58)

    // DATOS DE EJEMPLO — se reemplazan con lo que venga de la base de datos
    private let misReportes: [(icono: String, titulo: String, estado: String, colorEstado: Color,
                               plataforma: String, fecha: String, codigo: String)] = [
        ("⏳", "Depto Condesa — anfitrión desapareció tras cobro", "EN REVISIÓN",
         Color("ReviewColor"), "Facebook Marketplace", "12 mar 2026", "RS-2026-0089"),
        ("📋", "Penthouse Roma Norte — cambio de último minuto", "PENDIENTE",
         Color.gray, "WhatsApp", "1 mar 2026", "RS-2026-0086")
    ]

    private let reportesRecientes: [(imagen: String, precio: String, titulo: String, plataforma: String,
                                     ubicacion: String, fecha: String, etiqueta: String, votos: String)] = [
        ("https://images.unsplash.com/photo-1512917774080-9991f1c4c750", "$4,200",
         "Depto amueblado Condesa — nunca existió", "Facebook Marketplace",
         "Condesa, CDMX", "12 mar 2026", "Propiedad fantasma", "47"),
        ("https://images.unsplash.com/photo-1600585154340-be6161a56a0c", "$8,500",
         "Casa en Tulum — fotos robadas de Airbnb", "Airbnb (cuenta clonada)",
         "Aldea Zama, Tulum", "28 feb 2026", "Clonación de anuncio", "63")
    ]

    // TabView
    var body: some View {
        TabView(selection: $selectedTab) {

            pantallaInicio
                .tabItem {
                    Label("Inicio", systemImage: "house")
                }
                .tag(Tab.inicio)

            NavigationStack {
                ReportsView()
            }
            .tabItem {
                Label("Reportes", systemImage: "exclamationmark.triangle")
            }
            .tag(Tab.reportes)

            NavigationStack {
                CreateReportView()
            }
            .tabItem {
                Label(".", systemImage: "plus.app.fill")
            }
            .tag(Tab.crear)

            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("Dashboard", systemImage: "square.grid.2x2")
            }
            .tag(Tab.dashboard)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Perfil", systemImage: "person")
            }
            .tag(Tab.perfil)
        }
        .tint(.red)
    }

    // Contenido de la pestaña Inicio
    private var pantallaInicio: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("OFRAUD STAY")
                                .font(.system(size: 12, weight: .bold))
                                .kerning(1.2)
                                .foregroundStyle(rojo)
                            Text("Inicio")
                                .font(.system(size: 26, weight: .bold, design: .serif))
                                .foregroundStyle(textoPrincipal)
                        }
                        Spacer()
                        Image("appLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .background(rojo.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(rojo.opacity(0.25), lineWidth: 1)
                            )
                    }
                    .padding(.top, 8)

                    // Tarjeta de alerta
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 10) {
                            Text("ALERTA ACTIVA")
                                .font(.system(size: 11, weight: .bold))
                                .kerning(0.8)
                                .foregroundStyle(rojo)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(rojo.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            Text("CDMX · 2026")
                                .font(.system(size: 13))
                                .foregroundStyle(textoGris)
                        }

                        HStack(spacing: 10) {
                            // DATOS DINÁMICOS: la cifra vendrá de la base de datos
                            Text("+1,600 afectados por fraudes en rentas vacacionales")
                                .font(.system(size: 17, weight: .bold, design: .serif))
                                .foregroundStyle(textoPrincipal)
                                .fixedSize(horizontal: false, vertical: true)

                            Spacer(minLength: 4)

                            VStack(spacing: 2) {
                                Text("4")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(rojo)
                                Text("Rep.")
                                    .font(.system(size: 11))
                                    .foregroundStyle(textoGris)
                            }
                            .frame(width: 50, height: 52)
                            .background(rojo.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                            VStack(spacing: 2) {
                                Text("2")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(verde)
                                Text("Verif.")
                                    .font(.system(size: 11))
                                    .foregroundStyle(textoGris)
                            }
                            .frame(width: 50, height: 52)
                            .background(verde.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(18)
                    .background(
                        ZStack(alignment: .topTrailing) {
                            rojo.opacity(0.07)
                            Circle()
                                .fill(rojo.opacity(0.06))
                                .frame(width: 120, height: 120)
                                .offset(x: 35, y: -35)
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(rojo.opacity(0.2), lineWidth: 1)
                    )

                    // Guías de seguridad
                    NavigationLink {
                        Text("Guías de seguridad") // Cambiar por la pantalla real cuando exista
                    } label: {
                        HStack(spacing: 14) {
                            Text("📖")
                                .font(.system(size: 20))
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Guías de seguridad")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(textoPrincipal)
                                Text("Propiedades verificadas y consejos antifraude")
                                    .font(.system(size: 12))
                                    .foregroundStyle(textoGris)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(verde)
                        }
                        .padding(16)
                        .background(verde.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(verde.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    // Botones Denunciar / Consultar
                    HStack(spacing: 12) {
                        NavigationLink {
                            CreateReportView()
                        } label: {
                            VStack(spacing: 12) {
                                Text("📋").font(.system(size: 26))
                                Text("Denunciar")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 106)
                            .background(rojo)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            ReportsView()
                        } label: {
                            VStack(spacing: 12) {
                                Text("🔍").font(.system(size: 26))
                                Text("Consultar")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(textoPrincipal)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 106)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(borde, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    // Mis reportes
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Mis reportes")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(textoPrincipal)
                            Spacer()
                            NavigationLink {
                                ReportsView()
                            } label: {
                                Text("Ver más →")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(rojo)
                            }
                        }
                        Text("Pendientes o en revisión · editables hasta que el admin los valide")
                            .font(.system(size: 13))
                            .foregroundStyle(textoGris)
                    }
                    .padding(.top, 8)

                    // Una tarjeta por cada reporte del usuario
                    ForEach(misReportes.indices, id: \.self) { i in
                        let reporte = misReportes[i]

                        VStack(alignment: .leading, spacing: 14) {
                            HStack(alignment: .top, spacing: 14) {

                                Text(reporte.icono)
                                    .font(.system(size: 24))
                                    .frame(width: 48, height: 48)
                                    .background(reporte.colorEstado.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(reporte.titulo)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(textoPrincipal)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("\(reporte.plataforma) · \(reporte.fecha)")
                                        .font(.system(size: 14))
                                        .foregroundStyle(textoGris)
                                    Text(reporte.codigo)
                                        .font(.system(size: 12, design: .monospaced))
                                        .foregroundStyle(textoGris)
                                }

                                Spacer(minLength: 4)

                                Text(reporte.estado)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(reporte.colorEstado)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(reporte.colorEstado.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }

                            HStack(spacing: 10) {
                                Button {
                                    // PENDIENTE: abrir pantalla para editar el reporte
                                } label: {
                                    Text("✏️ Editar")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(textoPrincipal)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 38)
                                        .background(fondo)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(borde, lineWidth: 1)
                                        )
                                }

                                Button {
                                    // PENDIENTE: confirmar y eliminar en la base de datos
                                } label: {
                                    Text("🗑️ Eliminar")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(rojo)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 38)
                                        .background(rojo.opacity(0.06))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(rojo.opacity(0.25), lineWidth: 1)
                                        )
                                }
                            }
                            .padding(.leading, 62)
                        }
                        .padding(18)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(borde, lineWidth: 1)
                        )
                    }

                    // Reportes recientes
                    HStack {
                        Text("Reportes recientes")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(textoPrincipal)
                        Spacer()
                        NavigationLink {
                            ReportsView()
                        } label: {
                            Text("Ver todos →")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(rojo)
                        }
                    }
                    .padding(.top, 8)

                    // Reportes verificados de la comunidad
                    ForEach(reportesRecientes.indices, id: \.self) { i in
                        let reporte = reportesRecientes[i]

                        NavigationLink {
                            Text("Detalle de \(reporte.titulo)")
                        } label: {
                            VStack(alignment: .leading, spacing: 12) {

                                ZStack(alignment: .top) {
                                    AsyncImage(url: URL(string: reporte.imagen)) { fase in
                                        if let imagen = fase.image {
                                            imagen
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } else {
                                            Rectangle().fill(borde)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 150)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                    HStack {
                                        Text("VERIFICADO")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundStyle(verde)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.white.opacity(0.9))
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                        Spacer()
                                        Text(reporte.precio)
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(rojo)
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                    }
                                    .padding(10)
                                }

                                Text(reporte.titulo)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(textoPrincipal)
                                    .multilineTextAlignment(.leading)

                                HStack {
                                    Text(reporte.plataforma)
                                    Spacer()
                                    Text(reporte.ubicacion)
                                }
                                .font(.system(size: 13))
                                .foregroundStyle(textoGris)

                                HStack(spacing: 8) {
                                    Text(reporte.etiqueta)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundStyle(textoGris)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(fondo)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                    Spacer()
                                    Text(reporte.fecha)
                                    Text("▲ \(reporte.votos)")
                                        .fontWeight(.bold)
                                }
                                .font(.system(size: 12))
                                .foregroundStyle(textoGris)
                            }
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(borde, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .background(fondo.ignoresSafeArea())
        }
    }
}

#Preview {
    StartView()
}
