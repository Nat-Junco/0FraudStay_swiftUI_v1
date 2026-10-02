//
//  CreateReportView.swift
//  0FraudStay_swiftUI_v1
//



import SwiftUI

struct CreateReportView: View {
    @Environment(\.dismiss) var dismiss
    
    // Control de flujo por pasos
    @State private var pasoActual = 1
    
    // Datos del formulario
    @State private var titulo = ""
    @State private var plataforma = "Facebook Marketplace"
    @State private var precio = ""
    @State private var ubicacion = ""
    @State private var tipoFraude = "Propiedad fantasma"
    @State private var descripcion = ""
    @State private var contactoVendedor = ""
    @State private var enlaceAnuncio = ""
    @State private var evidenciaSubida = false
    
    // Colores
    private let rojo = Color("BrandPrimaryColor")
    private let verde = Color("VerificateColor")
    private let fondo = Color("FondoApp")
    private let borde = Color("Border")
    private let textoPrincipal = Color(.black)
    private let textoGris = Color(.lightGray)
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("OFRAUD STAY")
                            .font(.system(size: 12, weight: .bold))
                            .kerning(1.2)
                            .foregroundStyle(rojo)
                        Text("Crear reporte")
                            .font(.system(size: 26, weight: .bold, design: .serif))
                            .foregroundStyle(textoPrincipal)
                    }
                    Spacer()
                    
                    Image("appLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .background(Color("FondoApp"))
                }
                
                // Barra de progreso de 3 pasos
                HStack(spacing: 8) {
                    ForEach(1...3, id: \.self) { paso in
                        Rectangle()
                            .fill(paso <= pasoActual ? rojo : borde)
                            .frame(height: 4)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
            .background(Color("FondoApp"))
            
            
            // Contenido dinamico
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    switch pasoActual {
                    case 1:
                        pasoUnoVista
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    case 2:
                        pasoDosVista
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    case 3:
                        pasoTresVista
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    default:
                        EmptyView()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
            .background(fondo)
            
            // Botones de navegacion
            HStack(spacing: 12) {
                if pasoActual > 1 {
                    Button {
                        withAnimation(.easeInOut) {
                            pasoActual -= 1
                        }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Atrás")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(textoPrincipal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(borde, lineWidth: 1)
                        )
                    }
                }
                
                Button {
                    withAnimation(.easeInOut) {
                        if pasoActual < 3 {
                            pasoActual += 1
                        } else {
                            dismiss()
                        }
                    }
                } label: {
                    HStack {
                        Text(pasoActual == 3 ? "Enviar Reporte" : "Siguiente")
                        Image(systemName: pasoActual == 3 ? "paperplane.fill" : "arrow.right")
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(rojo)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.white)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(borde),
                alignment: .top
            )
        }
    }
    
    
    // PASO 1
    private var pasoUnoVista: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Indicador de Paso
            VStack(alignment: .leading, spacing: 6) {
                Text("PASO 1 DE 3")
                    .font(.system(size: 11, weight: .bold))
                    .kerning(0.8)
                    .foregroundStyle(rojo)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(rojo.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                
                Text("Detalles de la propiedad u oferta")
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .foregroundStyle(textoPrincipal)
            }
            
            // Formulario
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Título del anuncio")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(textoPrincipal)
                    
                    TextField("Ej. Depa amueblado en Roma Sur", text: $titulo)
                        .padding(12)
                        .background(fondo)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(borde, lineWidth: 1))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Plataforma")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(textoPrincipal)
                    
                    Picker("Plataforma", selection: $plataforma) {
                        Text("Facebook Marketplace").tag("Facebook Marketplace")
                        Text("WhatsApp").tag("WhatsApp")
                        Text("Airbnb").tag("Airbnb")
                        Text("Otra").tag("Otra")
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(fondo)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(borde, lineWidth: 1))
                }
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Precio")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(textoPrincipal)
                        
                        TextField("$0.00", text: $precio)
                            .keyboardType(.numberPad)
                            .padding(12)
                            .background(fondo)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(borde, lineWidth: 1))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Ubicación / Zona")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(textoPrincipal)
                        
                        TextField("Ej. Condesa", text: $ubicacion)
                            .padding(12)
                            .background(fondo)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(borde, lineWidth: 1))
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(borde, lineWidth: 1))
        }
    }
    
    // PASO 2
    private var pasoDosVista: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            VStack(alignment: .leading, spacing: 6) {
                Text("PASO 2 DE 3")
                    .font(.system(size: 11, weight: .bold))
                    .kerning(0.8)
                    .foregroundStyle(rojo)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(rojo.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                
                Text("¿Qué sucedió?")
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .foregroundStyle(textoPrincipal)
            }
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Tipo de anomalía")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(textoPrincipal)
                    
                    Picker("Tipo de Fraude", selection: $tipoFraude) {
                        Text("Propiedad fantasma").tag("Propiedad fantasma")
                        Text("Anticipo sin entrega").tag("Anticipo sin entrega")
                        Text("Clonación de anuncio").tag("Clonación de anuncio")
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(fondo)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(borde, lineWidth: 1))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Explicación de la experiencia")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(textoPrincipal)
                    
                    TextEditor(text: $descripcion)
                        .frame(height: 120)
                        .padding(8)
                        .scrollContentBackground(.hidden)
                        .background(fondo)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(borde, lineWidth: 1))
                }
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(borde, lineWidth: 1))
        }
    }
    
    // PASO 3
    private var pasoTresVista: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            VStack(alignment: .leading, spacing: 6) {
                Text("PASO 3 DE 3")
                    .font(.system(size: 11, weight: .bold))
                    .kerning(0.8)
                    .foregroundStyle(rojo)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(rojo.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                
                Text("Evidencias y datos de contacto")
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .foregroundStyle(textoPrincipal)
            }
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Número / Perfil del ofertante")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(textoPrincipal)
                    
                    TextField("Ej. +52 55 0000 0000", text: $contactoVendedor)
                        .padding(12)
                        .background(fondo)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(borde, lineWidth: 1))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Subir capturas de pantalla o evidencia")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(textoPrincipal)
                    
                    Button {
                        evidenciaSubida.toggle()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: evidenciaSubida ? "checkmark.circle.fill" : "arrow.up.doc.fill")
                                .foregroundStyle(evidenciaSubida ? verde : rojo)
                            Text(evidenciaSubida ? "Evidencias adjuntadas" : "Seleccionar imágenes / PDF")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(textoPrincipal)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(evidenciaSubida ? verde.opacity(0.1) : fondo)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(evidenciaSubida ? verde.opacity(0.4) : borde, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(borde, lineWidth: 1))
        }
    }
}

#Preview {
    NavigationStack {
        CreateReportView()
    }
}

