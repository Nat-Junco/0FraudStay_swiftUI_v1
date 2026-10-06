//
//  CreateReportView.swift
//  0FraudStay_swiftUI_v1
//



//  Flujo de 3 pasos conectado al back:
//  Paso 1 — Fotos (portada + evidencia) y datos del anuncio. Las 2 fotos se
//           suben juntas a POST /reportes/fotos en cuanto están las dos.
//  Paso 2 — ¿Qué sucedió?: tipo de fraude, descripción, precio, contacto.
//  Paso 3 — Ubicación: pin en el mapa (autollena la zona) y se envía
//           POST /reportes con los `fotoTemps` del paso 1.
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
    @State private var portadaItem: PhotosPickerItem?
    @State private var evidenciaItem: PhotosPickerItem?
    @State private var portadaPreview: UIImage?
    @State private var evidenciaPreview: UIImage?
    @State private var portadaJPEG: Data?
    @State private var evidenciaJPEG: Data?
    @State private var fotoTemps: [String]?      // [portada, evidencia] ya subidas
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
    @State private var buscandoZona = false
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
            if subiendoFoto { errores.append("Espera a que terminen de subir las fotos") }
            else if portadaJPEG == nil { errores.append("Selecciona la foto de portada") }
            else if evidenciaJPEG == nil { errores.append("Selecciona la foto de evidencia") }
            else if fotoTemps == nil { errores.append("Las fotos no se subieron, selecciona una de nuevo para reintentar") }
            if titulo.esVacio { errores.append("Escribe el título del anuncio") }
            if fuenteId == nil { errores.append("Selecciona la plataforma") }
            if tipoPropiedadId == nil { errores.append("Selecciona el tipo de propiedad") }
        case 2:
            if tipoFraudeId == nil { errores.append("Selecciona el tipo de fraude") }
            if descripcion.esVacio { errores.append("Describe lo que sucedió") }
            if !precio.esVacio && !precio.esPrecioValido {
                errores.append("El precio solo puede tener números y máximo 2 decimales")
            }
            if !contactoOfertante.esVacio && !contactoOfertante.esTelefonoValido {
                errores.append("El contacto debe ser un teléfono válido (10 dígitos o más, sin letras)")
            }
        default:
            if !zona.esVacio && !zona.esZonaValida {
                errores.append("La zona solo puede tener letras, números, espacios y . , # -")
            }
            if coordenada == nil { errores.append("Toca el mapa para marcar la ubicación") }
        }
        return errores
    }
    
    // MARK: - Fotos (paso 1)
    /// Convierte lo elegido en la galería a imagen + JPEG comprimido (70%)
    private func cargarImagen(_ item: PhotosPickerItem?) async -> (imagen: UIImage, jpeg: Data)? {
        guard let item,
              let data = try? await item.loadTransferable(type: Data.self),
              let imagen = UIImage(data: data),
              let jpeg = imagen.jpegData(compressionQuality: 0.7) else { return nil }
        return (imagen, jpeg)
    }

    /// Se llama cuando cambia la portada o la evidencia
    private func fotoSeleccionada(_ item: PhotosPickerItem?, esPortada: Bool) async {
        guard let resultado = await cargarImagen(item) else {
            if item != nil { errorFoto = "No se pudo leer la imagen" }
            return
        }
        if esPortada {
            portadaPreview = resultado.imagen
            portadaJPEG = resultado.jpeg
        } else {
            evidenciaPreview = resultado.imagen
            evidenciaJPEG = resultado.jpeg
        }
        await subirFotosSiEstanListas()
    }

    /// El back pide exactamente 2 fotos juntas: se suben cuando ya están las dos.
    /// Si el usuario cambia una, se vuelven a subir ambas.
    private func subirFotosSiEstanListas() async {
        fotoTemps = nil
        errorFoto = nil
        guard let portadaJPEG, let evidenciaJPEG else { return }
        subiendoFoto = true
        do {
            fotoTemps = try await controladorReportes.subirFotos(portada: portadaJPEG, evidencia: evidenciaJPEG)
        } catch {
            errorFoto = "No se pudieron subir las fotos. Selecciona una de nuevo para reintentar."
        }
        subiendoFoto = false
    }

    // MARK: - Autollenar zona con el pin (geocodificación inversa)
    private func autocompletarZona(_ c: CLLocationCoordinate2D) async {
        buscandoZona = true
        let ubicacion = CLLocation(latitude: c.latitude, longitude: c.longitude)
        do {
            let lugares = try await CLGeocoder().reverseGeocodeLocation(
                ubicacion, preferredLocale: Locale(identifier: "es_MX"))
            if let lugar = lugares.first {
                // "Condesa, Ciudad de México" → solo las partes que existan
                let partes = [lugar.subLocality, lugar.locality].compactMap { $0 }
                if !partes.isEmpty {
                    zona = partes.joined(separator: ", ")
                }
            }
        } catch {
            // Sin internet o sin resultado: el usuario puede escribirla a mano
            print("No se pudo obtener la zona: \(error.localizedDescription)")
        }
        buscandoZona = false
    }

    // MARK: - Enviar reporte (paso 3)
    private func enviarReporte() async {
        guard let fotoTemps, let fuenteId, let tipoPropiedadId,
              let tipoFraudeId, let coordenada else { return }
        enviando = true
        do {
            _ = try await controladorReportes.crear(
                nombre: titulo,
                descripcion: descripcion,
                latitud: coordenada.latitude,
                longitud: coordenada.longitude,
                fotoTemps: fotoTemps,
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
            erroresFormulario = ["El servidor rechazó el reporte. Revisa los datos o vuelve a seleccionar las fotos en el paso 1."]
        } catch ErrorAPI.status(409) {
            erroresFormulario = ["Plataforma, tipo de propiedad o tipo de fraude inválidos."]
        } catch {
            erroresFormulario = ["No se pudo enviar el reporte. \(error.localizedDescription)"]
        }
        enviando = false
    }
    
    private func limpiarFormulario() {
        pasoActual = 1
        portadaItem = nil; evidenciaItem = nil
        portadaPreview = nil; evidenciaPreview = nil
        portadaJPEG = nil; evidenciaJPEG = nil
        fotoTemps = nil; errorFoto = nil
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
                        Text("0FRAUD STAY")
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
        .onChange(of: portadaItem) { _, nuevo in
            Task { await fotoSeleccionada(nuevo, esPortada: true) }
        }
        .onChange(of: evidenciaItem) { _, nuevo in
            Task { await fotoSeleccionada(nuevo, esPortada: false) }
        }
        .onChange(of: precio) { _, nuevo in
            // Solo dígitos y un punto decimal
            var filtrado = nuevo.filter { "0123456789.".contains($0) }
            if filtrado.filter({ $0 == "." }).count > 1 {
                filtrado = String(filtrado.dropLast())
            }
            if filtrado != nuevo { precio = filtrado }
        }
        .onChange(of: contactoOfertante) { _, nuevo in
            // Solo dígitos, +, espacios y guiones
            let filtrado = nuevo.filter { "0123456789+ -".contains($0) }
            if filtrado != nuevo { contactoOfertante = filtrado }
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
    
    /// Recuadro para elegir una foto (se usa 2 veces: portada y evidencia)
    private func selectorFoto(_ titulo: String, _ ayuda: String,
                              _ item: Binding<PhotosPickerItem?>, _ preview: UIImage?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo.uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(textoGris)
            PhotosPicker(selection: item, matching: .images) {
                ZStack {
                    if let preview {
                        Image(uiImage: preview)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 140)
                            .clipped()
                    } else {
                        VStack(spacing: 6) {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 24))
                                .foregroundStyle(rojo)
                            Text(ayuda)
                                .font(.system(size: 11))
                                .foregroundStyle(textoGris)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 6)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 140)
                        .background(fondo)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(fotoTemps != nil ? verde.opacity(0.5) : borde,
                                style: StrokeStyle(lineWidth: 1, dash: preview == nil ? [6] : []))
                )
            }
            .disabled(subiendoFoto)
        }
        .frame(maxWidth: .infinity)
    }

    /// Texto de estado debajo de las 2 fotos
    @ViewBuilder private var estadoFotos: some View {
        if subiendoFoto {
            HStack(spacing: 6) {
                ProgressView()
                Text("Subiendo fotos…")
            }
            .font(.caption)
            .foregroundStyle(.gray)
        } else if fotoTemps != nil {
            Label("Fotos subidas · toca una para cambiarla", systemImage: "checkmark.circle.fill")
                .font(.caption)
                .foregroundStyle(verde)
        } else if let errorFoto {
            Text(errorFoto)
                .font(.caption)
                .foregroundStyle(.red)
        } else if portadaJPEG != nil || evidenciaJPEG != nil {
            Text("Selecciona las dos fotos para subirlas")
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }

    // MARK: - PASO 1: Evidencia y anuncio
    private var pasoUnoVista: some View {
        VStack(alignment: .leading, spacing: 20) {
            encabezadoPaso(1, "Evidencia y datos del anuncio")
            
            tarjeta {
                VStack(alignment: .leading, spacing: 8) {
                    etiqueta("Fotos del reporte")
                    HStack(spacing: 12) {
                        selectorFoto("Portada", "Foto del anuncio", $portadaItem, portadaPreview)
                        selectorFoto("Evidencia", "Chat, pago o comprobante", $evidenciaItem, evidenciaPreview)
                    }
                    estadoFotos
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
                            .keyboardType(.phonePad)
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
                    if buscandoZona {
                        Text("Buscando zona…")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    etiqueta("Marca la ubicación en el mapa (llena la zona automáticamente)")
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
                                Task { await autocompletarZona(c) }
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
