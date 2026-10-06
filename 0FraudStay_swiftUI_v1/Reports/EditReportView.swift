//
//  EditReportView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by Javier Padilla Marcial on 06/10/26.
//  Editar reporte (PATCH /reportes/:id). Solo se pueden editar reportes
//  Pendientes o En revisión. El estado NO se edita aquí: lo cambia el admin.
//  Las fotos y la ubicación tampoco se editan en esta pantalla.
//

import SwiftUI

struct EditReportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.reportesController) var controladorReportes
    @EnvironmentObject var vm: ReportesViewModel

    let reporte: DTOReporteResponse

    @State private var nombre = ""
    @State private var descripcion = ""
    @State private var fuenteId = 0
    @State private var tipoPropiedadId = 0
    @State private var tipoFraudeId = 0
    @State private var precio = ""
    @State private var zona = ""
    @State private var contactoOfertante = ""
    @State private var guardando = false
    @State private var errores: [String] = []

    private let rojo = Color("BrandPrimaryColor")

    private var precioNumero: Double? {
        Double(precio.trimmingCharacters(in: .whitespaces))
    }

    // MARK: - Validación (mismas reglas que el back)
    private func validar() -> [String] {
        var e: [String] = []
        if nombre.esVacio { e.append("El título no puede estar vacío") }
        if descripcion.esVacio { e.append("La descripción no puede estar vacía") }
        if !precio.esVacio && !precio.esPrecioValido {
            e.append("El precio solo puede tener números y máximo 2 decimales")
        }
        if !zona.esVacio && !zona.esZonaValida {
            e.append("La zona solo puede tener letras, números, espacios y . , # -")
        }
        if !contactoOfertante.esVacio && !contactoOfertante.esTelefonoValido {
            e.append("El contacto debe ser un teléfono válido (sin letras)")
        }
        return e
    }

    // MARK: - Guardar (PATCH /reportes/:id)
    private func guardar() async {
        errores = validar()
        guard errores.isEmpty else { return }

        guardando = true
        let cambios = DTOActualizarReporteRequest(
            nombre: nombre,
            descripcion: descripcion,
            fuenteId: fuenteId,
            tipoPropiedadId: tipoPropiedadId,
            tipoFraudeId: tipoFraudeId,
            precio: precioNumero,
            zona: zona.esVacio ? nil : zona,
            contactoOfertante: contactoOfertante.esVacio ? nil : contactoOfertante
        )
        do {
            _ = try await controladorReportes.actualizar(id: reporte.id, cambios: cambios)
            await vm.cargarTodo()
            dismiss()
        } catch ErrorAPI.status(400) {
            errores = ["El servidor rechazó los cambios. Revisa los datos."]
        } catch ErrorAPI.status(404) {
            errores = ["Este reporte ya no existe."]
        } catch {
            errores = ["No se pudo guardar. \(error.localizedDescription)"]
        }
        guardando = false
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Anuncio") {
                    TextField("Título", text: $nombre)
                    Picker("Plataforma", selection: $fuenteId) {
                        ForEach(vm.fuentes) { Text($0.valorFuente).tag($0.id) }
                    }
                    Picker("Tipo de propiedad", selection: $tipoPropiedadId) {
                        ForEach(vm.tiposPropiedad) { Text($0.nombre).tag($0.id) }
                    }
                }

                Section("¿Qué sucedió?") {
                    Picker("Tipo de fraude", selection: $tipoFraudeId) {
                        ForEach(vm.tiposFraude) { Text($0.nombre).tag($0.id) }
                    }
                    TextEditor(text: $descripcion)
                        .frame(minHeight: 120)
                }

                Section("Datos adicionales (opcionales)") {
                    TextField("Precio", text: $precio)
                        .keyboardType(.decimalPad)
                    TextField("Zona / Colonia", text: $zona)
                    TextField("Contacto del ofertante", text: $contactoOfertante)
                        .keyboardType(.phonePad)
                }

                if !errores.isEmpty {
                    Section {
                        ResumenErrores(errores: errores)
                    }
                }
            }
            .navigationTitle("Editar \(reporte.folio)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(guardando ? "Guardando…" : "Guardar") {
                        Task { await guardar() }
                    }
                    .disabled(guardando)
                }
            }
            .tint(rojo)
            .onChange(of: precio) { _, nuevo in
                var filtrado = nuevo.filter { "0123456789.".contains($0) }
                if filtrado.filter({ $0 == "." }).count > 1 {
                    filtrado = String(filtrado.dropLast())
                }
                if filtrado != nuevo { precio = filtrado }
            }
            .onChange(of: contactoOfertante) { _, nuevo in
                let filtrado = nuevo.filter { "0123456789+ -".contains($0) }
                if filtrado != nuevo { contactoOfertante = filtrado }
            }
            .onAppear {
                // Precargar los datos actuales del reporte
                nombre = reporte.nombre
                descripcion = reporte.descripcion
                fuenteId = reporte.fuenteId
                tipoPropiedadId = reporte.tipoPropiedadId
                tipoFraudeId = reporte.tipoFraudeId
                precio = reporte.precio.map { String(format: "%.2f", $0) } ?? ""
                zona = reporte.zona ?? ""
                contactoOfertante = reporte.contactoOfertante ?? ""
            }
        }
    }
}
