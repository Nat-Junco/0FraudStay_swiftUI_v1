//
//  StartView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import SwiftUI
struct ReportDetail: Identifiable {
    let id: String
    let imageUrls: [String]
    let estado: String
    let tipoFraude: String
    let titulo: String
    let plataforma: String
    let ubicacion: String
    let fecha: String
    let montoDefraudado: String
    let descripcion: String
    let nombreEstafador: String
    let linkEstafador: String
    var evidenciaUrls: [String]?
}
enum Tab {
    case inicio
    case reportes
    case crear
    case guides
    case perfil
}

struct MiReporteItem: Identifiable {
    let id = UUID()
    let systemIcon: String
    let titulo: String
    let estado: String
    let colorEstado: Color
    let plataforma: String
    let fecha: String
    let codigo: String
}
struct StartView: View {
    
    @State private var selectedTab: Tab = .inicio
    
    private let rojo = Color("BrandPrimaryColor")
    private let verde = Color("VerificateColor")
    private let fondo = Color("FondoApp")
    private let borde = Color("Border")
    private let textoPrincipal = Color(.black)
    private let textoGris = Color(.lightGray)
    
    private let misReportes: [MiReporteItem] = [
        MiReporteItem(
            systemIcon: "clock.fill",
            titulo: "Depto Condesa — anfitrión desapareció tras cobro",
            estado: "EN REVISIÓN",
            colorEstado: Color("ReviewColor"),
            plataforma: "Facebook Marketplace",
            fecha: "12 mar 2026",
            codigo: "RS-2026-0089"
        ),
        MiReporteItem(
            systemIcon: "doc.text.fill",
            titulo: "Penthouse Roma Norte — cambio de último minuto",
            estado: "PENDIENTE",
            colorEstado: .gray,
            plataforma: "WhatsApp",
            fecha: "1 mar 2026",
            codigo: "RS-2026-0086"
        )
    ]
    
    private let reportesRecientes: [ReportDetail] = [
        ReportDetail(
            id: "1",
            imageUrls: ["https://images.unsplash.com/photo-1512917774080-9991f1c4c750"],
            estado: "VERIFICADO",
            tipoFraude: "PROPIEDAD FANTASMA",
            titulo: "Depto amueblado Condesa — nunca existió",
            plataforma: "Facebook Marketplace",
            ubicacion: "Condesa, CDMX",
            fecha: "12 mar 2026",
            montoDefraudado: "$4,200 MXN",
            descripcion: "Publicación de departamento en Condesa por $4,200. Al enviar anticipo por transferencia, el anfitrión desapareció.",
            nombreEstafador: "Carlos R. / 'Rentas CDMX'",
            linkEstafador: "facebook.com/marketplace/item/839201"
        ),
        ReportDetail(
            id: "2",
            imageUrls: ["https://images.unsplash.com/photo-1600585154340-be6161a56a0c"],
            estado: "VERIFICADO",
            tipoFraude: "CLONACIÓN DE ANUNCIO",
            titulo: "Casa en Tulum — fotos robadas de Airbnb",
            plataforma: "Airbnb (cuenta clonada)",
            ubicacion: "Aldea Zama, Tulum",
            fecha: "28 feb 2026",
            montoDefraudado: "$8,500 MXN",
            descripcion: "Cuenta clonada ofreciendo villa en Tulum a la mitad del precio del mercado.",
            nombreEstafador: "Rentas Tulum Exclusivas",
            linkEstafador: "instagram.com/tulum_rentas_fake"
        )
    ]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            pantallaInicio
                .tabItem {
                    Label("Inicio", systemImage: "house")
                }
                .tag(Tab.inicio)
            
            NavigationStack {
                AllReportsView()
            }
            .tabItem {
                Label("Reportes", systemImage: "exclamationmark.triangle")
            }
            .tag(Tab.reportes)
            
            NavigationStack {
                CreateReportView()
            }
            .tabItem {
                Label("Crear", systemImage: "plus.app.fill")
            }
            .tag(Tab.crear)
            
            NavigationStack {
                GuidesView()
            }
            .tabItem {
                Label("Guías", systemImage: "book")
            }
            .tag(Tab.guides)
            
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
                            .frame(width: 70, height: 70)
                            .background(fondo)
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
                        GuidesView()
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(verde)
                            
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
                    
                    // Botones Denunciar y consultar
                    HStack(spacing: 12) {
                        NavigationLink {
                            CreateReportView()
                        } label: {
                            VStack(spacing: 10) {
                                Image(systemName: "square.and.pencil")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(.white)
                                
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
                            AllReportsView()
                        } label: {
                            VStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(textoPrincipal)
                                
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
                                MyReportsView()
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
                    
                    // Lista de Mis Reportes
                    ForEach(misReportes) { reporte in
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(alignment: .top, spacing: 14) {
                                
                                Image(systemName: reporte.systemIcon)
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(reporte.colorEstado)
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
                                    // Agregar funcionalidad
                                } label: {
                                    Text("Editar")
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
                                    // Agregar funcionalidad
                                } label: {
                                    Text("Eliminar")
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
                
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Reportes Recientes")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(textoPrincipal)
                            Spacer()
                            NavigationLink {
                                AllReportsView()
                            } label: {
                                Text("Ver más →")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(rojo)
                            }
                        }
                        Text("Últimas denuncias y alertas registradas")
                            .font(.system(size: 13))
                            .foregroundStyle(textoGris)
                    }
                    .padding(.top, 12)
                    
                    //Reportes Recientes
                    ForEach(reportesRecientes) { reporte in
                        NavigationLink {
                            ReportDetailView(reporte: reporte)
                        } label: {
                            VStack(alignment: .leading, spacing: 12) {
                                ZStack(alignment: .top) {
                                    if let firstUrl = reporte.imageUrls.first {
                                        AsyncImage(url: URL(string: firstUrl)) { fase in
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
                                    }
                                    
                                    HStack {
                                        Text(reporte.estado)
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundStyle(verde)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.white.opacity(0.9))
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                        Spacer()
                                        Text(reporte.montoDefraudado)
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
                                    Text(reporte.tipoFraude)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundStyle(textoGris)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(fondo)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                    Spacer()
                                    Text(reporte.fecha)
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

