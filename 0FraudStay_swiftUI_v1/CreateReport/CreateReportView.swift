//
//  CreateReportView.swift
//  0FraudStay_swiftUI_v1
//



import SwiftUI
import PhotosUI
import MapKit

struct CreateReportView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.reportesController) var controladorReportes
    @EnvironmentObject var vm: ReportesViewModel
    
    @State private var pasoActual = 1
    
    // Paso 1
    @State private var fotoItem: PhotosPickerItem?
    @State private var fotoPreview: UIImage?
    @State private var fotoTemp: String?
    @State private var subiendoFoto = false
    @State private var errorFoto: String?
    @State private var titulo = ""
    @State private var fuenteId: Int?
    @State private var tipoPropiedadId: Int?
    
    // Paso 2
    @State private var tipoFraudeId: Int?
    @State private var descripcion = ""
    @State private var precio = ""
    @State private var contactoOfertante = ""
    
    // Paso 3
    @State private var zona = ""
    @State private var coordenada: CLLocationCoordinate2D?
    @State private var camara: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
        span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)))
    
    // Envío
    @State private var enviando = false
    @State private var erroresFormulario: [String] = []
    @State private var reporteCreado = false
    
    // Colores
    private let rojo = Color("BrandPrimaryColor")
    private let verde = Color("VerificateColor")
    private let fondo = Color("FondoApp")
    private let borde = Color("Border")
    private let textoPrincipal = Color(.black)
    private let textoGris = Color(.lightGray)
    
    /// "4,200.50" → 4200.5 ; vacío → nil
    private var precioNumero: Double? {
        Double(precio.replacingOccurrences(of: ",", with: "")
                     .replacingOccurrences(of: "$", with: "")
                     .trimmingCharacters(in: .whitespaces))
    }
    
    // MARK: - Validación por paso
    private func erroresDelPaso(_ paso: Int) -> [String] {
        var errores: [String] = []
        switch paso {
        case 1:
            if subiendoFoto { errores.append("Espera a que termine de subir la foto") }
            else if fotoTemp == nil { errores.append("Adjunta una foto de evidencia") }
            if titulo.esVacio { errores.append("Escribe el título del anuncio") }
            if fuenteId == nil { errores.append("Selecciona la plataforma") }
            if tipoPropiedadId == nil { errores.append("Selecciona el tipo de propiedad") }
        case 2:
            if tipoFraudeId == nil { errores.append("Selecciona el tipo de fraude") }
            if descripcion.esVacio { errores.append("Describe lo que sucedió") }
            if !precio.esVacio && precioNumero == nil { errores.append("El precio debe ser un número") }
        default:
            if coordenada == nil { errores.append("Toca el mapa para marcar la ubicación") }
        }
        return errores
    }
    
    // MARK: - Subir foto (paso 1, al elegirla)
    private func subirFoto(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        errorFoto = nil
        fotoTemp = nil
        guard let data = try? await item.loadTransferable(type: Data.self),
              let imagen = UIImage(data: data),
              let jpeg = imagen.jpegData(compressionQuality: 0.7) else {
            errorFoto = "No se pudo leer la imagen"
            return
        }
        fotoPreview = imagen
        subiendoFoto = true
        do {
            fotoTemp = try await controladorReportes.subirFoto(jpeg)
        } catch {
            errorFoto = "No se pudo subir la foto. Toca para intentar de nuevo."
        }
        subiendoFoto = false
    }
    
    // MARK: - Enviar reporte (paso 3)
    private func enviarReporte() async {
        guard let fotoTemp, let fuenteId, let tipoPropiedadId,
              let tipoFraudeId, let coordenada else { return }
        enviando = true
        do {
            _ = try await controladorReportes.crear(
                nombre: titulo,
                descripcion: descripcion,
                latitud: coordenada.latitude,
                longitud: coordenada.longitude,
                fotoTemp: fotoTemp,
                fuenteId: fuenteId,
                tipoPropiedadId: tipoPropiedadId,
                tipoFraudeId: tipoFraudeId,
                precio: precioNumero,
                zona: zona.esVacio ? nil : zona,
                contactoOfertante: contactoOfertante.esVacio ? nil : contactoOfertante
            )
            await vm.cargarTodo()
            reporteCreado = true
        } catch ErrorAPI.status(400) {
            erroresFormulario = ["El servidor rechazó el reporte. Vuelve a subir la foto en el paso 1."]
            self.fotoTemp = nil
        } catch ErrorAPI.status(409) {
            erroresFormulario = ["Plataforma, tipo de propiedad o tipo de fraude inválidos."]
        } catch {
            erroresFormulario = ["No se pudo enviar el reporte. \(error.localizedDescription)"]
        }
        enviando = false
    }
    
    private func limpiarFormulario() {
        pasoActual = 1
        fotoItem = nil; fotoPreview = nil; fotoTemp = nil; errorFoto = nil
        titulo = ""; fuenteId = nil; tipoPropiedadId = nil
        tipoFraudeId = nil; descripcion = ""; precio = ""; contactoOfertante = ""
        zona = ""; coordenada = nil
        erroresFormulario = []
    }
    
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
                        .background(fondo)
                }
                
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
            .background(fondo)
            
            // Contenido dinámico
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
                    
                    if !erroresFormulario.isEmpty {
                        ResumenErrores(errores: erroresFormulario)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
            .background(fondo)
            
            // Botones de navegación
            HStack(spacing: 12) {
                if pasoActual > 1 {
                    Button {
                        erroresFormulario = []
                        withAnimation(.easeInOut) { pasoActual -= 1 }
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
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(borde, lineWidth: 1))
                    }
                }
                
                Button {
                    erroresFormulario = erroresDelPaso(pasoActual)
                    guard erroresFormulario.isEmpty else { return }
                    if pasoActual < 3 {
                        withAnimation(.easeInOut) { pasoActual += 1 }
                    } else {
                        Task { await enviarReporte() }
                    }
                } label: {
                    HStack {
                        if enviando {
                            ProgressView().tint(.white)
                        } else {
                            Text(pasoActual == 3 ? "Enviar Reporte" : "Siguiente")
                            Image(systemName: pasoActual == 3 ? "paperplane.fill" : "arrow.right")
                        }
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(rojo)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(enviando || subiendoFoto)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.white)
            .overlay(Rectangle().frame(height: 1).foregroundStyle(borde), alignment: .top)
        }
        .task {
            if vm.fuentes.isEmpty { await vm.cargarTodo() }
        }
        .onChange(of: fotoItem) { _, nuevo in
            Task { await subirFoto(nuevo) }
        }
        .alert("Reporte enviado", isPresented: $reporteCreado) {
            Button("Aceptar") {
                limpiarFormulario()
                dismiss()
            }
        } message: {
            Text("Tu reporte quedó como Pendiente hasta que un administrador lo revise.")
        }
    }
    
    // MARK: - Componentes reutilizables
    private func etiqueta(_ texto: String, opcional: Bool = false) -> some View {
        HStack(spacing: 4) {
            Text(texto)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(textoPrincipal)
            if opcional {
                Text("(opcional)")
                    .font(.system(size: 11))
                    .foregroundStyle(textoGris)
            }
        }
    }
    
    private func encabezadoPaso(_ numero: Int, _ titulo: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("PASO \(numero) DE 3")
                .font(.system(size: 11, weight: .bold))
                .kerning(0.8)
                .foregroundStyle(rojo)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(rojo.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            Text(titulo)
                .font(.system(size: 18, weight: .bold, design: .serif))
                .foregroundStyle(textoPrincipal)
        }
    }
    
    private func tarjeta<Contenido: View>(@ViewBuilder _ contenido: () -> Contenido) -> some View {
        VStack(spacing: 16) { contenido() }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(borde, lineWidth: 1))
    }
    
    private func campoTexto(_ placeholder: String, _ texto: Binding<String>) -> some View {
        TextField(placeholder, text: texto)
            .padding(12)
            .background(fondo)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(borde, lineWidth: 1))
    }
    
    private func selector<Item: Identifiable & Hashable>(
        _ titulo: String, _ seleccion: Binding<Int?>, _ items: [Item], _ texto: @escaping (Item) -> String
    ) -> some View where Item.ID == Int {
        Picker(titulo, selection: seleccion) {
            Text("Selecciona…").tag(Int?.none)
            ForEach(items) { item in
                Text(texto(item)).tag(Int?.some(item.id))
            }
        }
        .pickerStyle(.menu)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(fondo)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(borde, lineWidth: 1))
    }
    
    // MARK: - PASO 1: Evidencia y anuncio
    private var pasoUnoVista: some View {
        VStack(alignment: .leading, spacing: 20) {
            encabezadoPaso(1, "Evidencia y datos del anuncio")
            
            tarjeta {
                VStack(alignment: .leading, spacing: 6) {
                    etiqueta("Foto o captura de evidencia")
                    
                    PhotosPicker(selection: $fotoItem, matching: .images) {
                        ZStack {
                            if let fotoPreview {
                                Image(uiImage: fotoPreview)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 170)
                                    .frame(maxWidth: .infinity)
                                    .clipped()
                                
                                VStack {
                                    Spacer()
                                    HStack(spacing: 6) {
                                        if subiendoFoto {
                                            ProgressView().tint(.white)
                                            Text("Subiendo…")
                                        } else if fotoTemp != nil {
                                            Image(systemName: "checkmark.circle.fill")
                                            Text("Foto subida · toca para cambiar")
                                        } else {
                                            Image(systemName: "exclamationmark.triangle.fill")
                                            Text("Toca para intentar de nuevo")
                                        }
                                    }
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        (subiendoFoto ? Color.black : (fotoTemp != nil ? verde : rojo)).opacity(0.85)
                                    )
                                    .clipShape(Capsule())
                                    .padding(10)
                                }
                            } else {
                                VStack(spacing: 8) {
                                    Image(systemName: "photo.badge.plus")
                                        .font(.system(size: 28))
                                        .foregroundStyle(rojo)
                                    Text("Seleccionar imagen")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(textoPrincipal)
                                    Text("Captura del anuncio, chat o comprobante")
                                        .font(.system(size: 11))
                                        .foregroundStyle(textoGris)
                                }
                                .frame(height: 170)
                                .frame(maxWidth: .infinity)
                                .background(fondo)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(fotoTemp != nil ? verde.opacity(0.5) : borde,
                                        style: StrokeStyle(lineWidth: 1, dash: fotoPreview == nil ? [6] : []))
                        )
                    }
                    .disabled(subiendoFoto)
                    
                    if let errorFoto {
                        Text(errorFoto)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    etiqueta("Título del anuncio")
                    campoTexto("Ej. Depa amueblado en Roma Sur", $titulo)
                }
                
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        etiqueta("Plataforma")
                        selector("Plataforma", $fuenteId, vm.fuentes) { $0.valorFuente }
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        etiqueta("Propiedad")
                        selector("Tipo de propiedad", $tipoPropiedadId, vm.tiposPropiedad) { $0.nombre }
                    }
                }
            }
        }
    }
    
    // MARK: - PASO 2: ¿Qué sucedió?
    private var pasoDosVista: some View {
        VStack(alignment: .leading, spacing: 20) {
            encabezadoPaso(2, "¿Qué sucedió?")
            
            tarjeta {
                VStack(alignment: .leading, spacing: 6) {
                    etiqueta("Tipo de anomalía")
                    selector("Tipo de fraude", $tipoFraudeId, vm.tiposFraude) { $0.nombre }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    etiqueta("Explicación de la experiencia")
                    TextEditor(text: $descripcion)
                        .frame(height: 130)
                        .padding(8)
                        .scrollContentBackground(.hidden)
                        .background(fondo)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(borde, lineWidth: 1))
                }
                
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        etiqueta("Precio", opcional: true)
                        campoTexto("$0.00", $precio)
                            .keyboardType(.decimalPad)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        etiqueta("Contacto", opcional: true)
                        campoTexto("+52 55 0000 0000", $contactoOfertante)
                            .textInputAutocapitalization(.never)
                    }
                }
            }
        }
    }
    
    // MARK: - PASO 3: Ubicación
    private var pasoTresVista: some View {
        VStack(alignment: .leading, spacing: 20) {
            encabezadoPaso(3, "¿Dónde está la propiedad?")
            
            tarjeta {
                VStack(alignment: .leading, spacing: 6) {
                    etiqueta("Zona / Colonia", opcional: true)
                    campoTexto("Ej. Condesa, CDMX", $zona)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    etiqueta("Marca la ubicación en el mapa")
                    MapReader { proxy in
                        Map(position: $camara) {
                            if let coordenada {
                                Marker("Propiedad", coordinate: coordenada)
                                    .tint(rojo)
                            }
                        }
                        .onTapGesture { punto in
                            if let c = proxy.convert(punto, from: .local) {
                                coordenada = c
                            }
                        }
                    }
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(borde, lineWidth: 1))
                    
                    Text(coordenada.map { String(format: "📍 %.5f, %.5f", $0.latitude, $0.longitude) }
                         ?? "Toca el mapa para colocar el pin")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateReportView()
            .environmentObject(ReportesViewModel())
    }
}
