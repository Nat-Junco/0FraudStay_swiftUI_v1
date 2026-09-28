//
//  StartView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import SwiftUI

// MARK: - Modelos de Datos

struct ReporteUsuario: Identifiable {
    let id = UUID()
    let icono: String
    let titulo: String
    let estado: String
    let colorEstado: Color
    let plataforma: String
    let fecha: String
    let codigo: String
}

struct ReporteReciente: Identifiable {
    let id = UUID()
    let imagen: String
    let precio: String
    let titulo: String
    let plataforma: String
    let ubicacion: String
    let fecha: String
    let etiqueta: String
    let votos: String
}

// MARK: - Vista Principal

struct StartView: View {

    // Verde de "Verificado" y "Guías de seguridad"
    private let verde = Color(red: 0.20, green: 0.66, blue: 0.36)

    // DATOS DE EJEMPLO — después se reemplazación con base de datos / API
    private let misReportes: [ReporteUsuario] = [
        ReporteUsuario(
            icono: "hourglass",
            titulo: "Depto Condesa — anfitrión desapareció tras cobro",
            estado: "EN REVISIÓN",
            colorEstado: Color(red: 0.85, green: 0.55, blue: 0.05),
            plataforma: "Facebook Marketplace",
            fecha: "12 mar 2026",
            codigo: "RS-2026-0089"
        ),
        ReporteUsuario(
            icono: "doc.text",
            titulo: "Penthouse Roma Norte — cambio de último minuto",
            estado: "PENDIENTE",
            colorEstado: .gray,
            plataforma: "WhatsApp",
            fecha: "1 mar 2026",
            codigo: "RS-2026-0086"
        )
    ]

    private let reportesRecientes: [ReporteReciente] = [
        ReporteReciente(
            imagen: "https://images.unsplash.com/photo-1512917774080-9991f1c4c750",
            precio: "$4,200",
            titulo: "Depto amueblado Condesa — nunca existió",
            plataforma: "Facebook Marketplace",
            ubicacion: "Condesa, CDMX",
            fecha: "12 mar 2026",
            etiqueta: "Propiedad fantasma",
            votos: "47"
        ),
        ReporteReciente(
            imagen: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
            precio: "$8,500",
            titulo: "Casa en Tulum — fotos robadas de Airbnb",
            plataforma: "Airbnb (cuenta clonada)",
            ubicacion: "Aldea Zama, Tulum",
            fecha: "28 feb 2026",
            etiqueta: "Clonación de anuncio",
            votos: "63"
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: 1. Encabezado
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("OFRAUD STAY")
                                .font(.system(size: 12, weight: .bold))
                                .kerning(1.2)
                                .foregroundStyle(Color("Rojo", bundle: nil))
                            
                            Text("Inicio")
                                .font(.system(size: 26, weight: .bold, design: .serif))
                                .foregroundStyle(Color("TextoPrincipal", bundle: nil))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "house.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color("Rojo", bundle: nil))
                            .frame(width: 46, height: 46)
                            .background(Color("Rojo", bundle: nil).opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("Rojo", bundle: nil).opacity(0.25), lineWidth: 1)
                            )
                    }
                    .padding(.top, 8)

                    // MARK: 2. Tarjeta de alerta
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 10) {
                            Text("ALERTA ACTIVA")
                                .font(.system(size: 11, weight: .bold))
                                .kerning(0.8)
                                .foregroundStyle(Color("Rojo", bundle: nil))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color("Rojo", bundle: nil).opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            
                            Text("CDMX · 2026")
                                .font(.system(size: 13))
                                .foregroundStyle(Color("TextoGris", bundle: nil))
                        }

                        HStack(spacing: 10) {
                            Text("+1,600 afectados por fraudes en rentas vacacionales")
                                .font(.system(size: 17, weight: .bold, design: .serif))
                                .foregroundStyle(Color("TextoPrincipal", bundle: nil))
                                .fixedSize(horizontal: false, vertical: true)

                            Spacer(minLength: 4)

                            // Métrica: reportes
                            VStack(spacing: 2) {
                                Text("4")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(Color("Rojo", bundle: nil))
                                Text("Rep.")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color("TextoGris", bundle: nil))
                            }
                            .frame(width: 50, height: 52)
                            .background(Color("Rojo", bundle: nil).opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                            // Métrica: verificados
                            VStack(spacing: 2) {
                                Text("2")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(verde)
                                Text("Verif.")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color("TextoGris", bundle: nil))
                            }
                            .frame(width: 50, height: 52)
                            .background(verde.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(18)
                    .background(
                        ZStack(alignment: .topTrailing) {
                            Color("Rojo", bundle: nil).opacity(0.07)
                            Circle()
                                .fill(Color("Rojo", bundle: nil).opacity(0.06))
                                .frame(width: 120, height: 120)
                                .offset(x: 35, y: -35)
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color("Rojo", bundle: nil).opacity(0.2), lineWidth: 1)
                    )

                    // MARK: 3. Guías de seguridad
                    NavigationLink {
                        Text("Guías de seguridad") // Vista destino
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(verde)
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Guías de seguridad")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Color("TextoPrincipal", bundle: nil))
                                Text("Propiedades verificadas y consejos antifraude")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color("TextoGris", bundle: nil))
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

                    // MARK: 4. Botones Denunciar / Consultar
                    HStack(spacing: 12) {
                        NavigationLink {
                            Text("Crear reporte")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(.white)
                                Text("Denunciar")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 106)
                            .background(Color("Rojo", bundle: nil))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            Text("Reportes")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color("TextoPrincipal", bundle: nil))
                                Text("Consultar")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(Color("TextoPrincipal", bundle: nil))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 106)
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color("Borde", bundle: nil), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    // MARK: 5. Mis reportes
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Mis reportes")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color("TextoPrincipal", bundle: nil))
                            Spacer()
                            NavigationLink {
                                Text("Todos mis reportes")
                            } label: {
                                Text("Ver más →")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color("Rojo", bundle: nil))
                            }
                        }
                        Text("Pendientes o en revisión · editables hasta que el admin los valide")
                            .font(.system(size: 13))
                            .foregroundStyle(Color("TextoGris", bundle: nil))
                    }
                    .padding(.top, 8)

                    ForEach(misReportes) { reporte in
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(alignment: .top, spacing: 14) {
                                Image(systemName: reporte.icono)
                                    .font(.system(size: 20))
                                    .foregroundStyle(reporte.colorEstado)
                                    .frame(width: 48, height: 48)
                                    .background(reporte.colorEstado.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(reporte.titulo)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(Color("TextoPrincipal", bundle: nil))
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("\(reporte.plataforma) · \(reporte.fecha)")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("TextoGris", bundle: nil))
                                    Text(reporte.codigo)
                                        .font(.system(size: 12, design: .monospaced))
                                        .foregroundStyle(Color("TextoGris", bundle: nil))
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
                                    // Editar reporte
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "pencil")
                                        Text("Editar")
                                    }
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color("TextoPrincipal", bundle: nil))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 38)
                                    .background(Color("Fondo", bundle: nil))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("Borde", bundle: nil), lineWidth: 1)
                                    )
                                }

                                Button {
                                    // Eliminar reporte
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "trash")
                                        Text("Eliminar")
                                    }
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color("Rojo", bundle: nil))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 38)
                                    .background(Color("Rojo", bundle: nil).opacity(0.06))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("Rojo", bundle: nil).opacity(0.25), lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.leading, 62)
                        }
                        .padding(18)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color("Borde", bundle: nil), lineWidth: 1)
                        )
                    }

                    // MARK: 6. Reportes recientes
                    HStack {
                        Text("Reportes recientes")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("TextoPrincipal", bundle: nil))
                        Spacer()
                        NavigationLink {
                            Text("Reportes")
                        } label: {
                            Text("Ver todos →")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color("Rojo", bundle: nil))
                        }
                    }
                    .padding(.top, 8)

                    ForEach(reportesRecientes) { reporte in
                        NavigationLink {
                            Text("Detalle de \(reporte.titulo)")
                        } label: {
                            VStack(alignment: .leading, spacing: 12) {
                                ZStack(alignment: .top) {
                                    AsyncImage(url: URL(string: reporte.imagen)) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        case .failure(_), .empty:
                                            Rectangle()
                                                .fill(Color("Borde", bundle: nil))
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .foregroundStyle(Color("TextoGris", bundle: nil))
                                                )
                                        @unknown default:
                                            EmptyView()
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
                                            .background(Color("Rojo", bundle: nil))
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                    }
                                    .padding(10)
                                }

                                Text(reporte.titulo)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color("TextoPrincipal", bundle: nil))
                                    .multilineTextAlignment(.leading)

                                HStack {
                                    Text(reporte.plataforma)
                                    Spacer()
                                    Text(reporte.ubicacion)
                                }
                                .font(.system(size: 13))
                                .foregroundStyle(Color("TextoGris", bundle: nil))
                                
                                HStack {
                                    Text(reporte.etiqueta)
                                        .font(.system(size: 12, weight: .medium))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color("Fondo", bundle: nil))
                                        .clipShape(Capsule())
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "hand.thumbsup.fill")
                                        Text(reporte.votos)
                                    }
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color("TextoGris", bundle: nil))
                                }
                            }
                            .padding(16)
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color("Borde", bundle: nil), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }

                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    StartView()
}
