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

    // MARK: - Estados de error para cada campo
    @State private var errorNombre: String? = nil
    @State private var errorDescripcion: String? = nil
    @State private var errorPrecio: String? = nil
    @State private var errorZona: String? = nil
    @State private var errorContacto: String? = nil
    @State private var errorGeneral: String? = nil

    private let rojo = Color("BrandPrimaryColor")

    private var precioNumero: Double? {
        let textoLimpio = precio
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        
        guard !textoLimpio.isEmpty else { return nil }
        return Double(textoLimpio)
    }

    // MARK: - Validación individual
    private func validarFormulario() -> Bool {
        errorNombre = nil
        errorDescripcion = nil
        errorPrecio = nil
        errorZona = nil
        errorContacto = nil
        errorGeneral = nil
        var esValido = true

        if nombre.esVacio {
            errorNombre = "El título no puede estar vacío."
            esValido = false
        }
        if descripcion.esVacio {
            errorDescripcion = "La descripción no puede estar vacía."
            esValido = false
        }
        if !precio.esVacio && !precio.esPrecioValido {
            errorPrecio = "El precio solo puede tener números y máximo 2 decimales."
            esValido = false
        }
        if !zona.esVacio && !zona.esZonaValida {
            errorZona = "La zona solo puede tener letras, números, espacios y . , # -"
            esValido = false
        }
        if !contactoOfertante.esVacio && !contactoOfertante.esTelefonoValido {
            errorContacto = "El contacto debe ser un teléfono válido (sin letras)."
            esValido = false
        }

        return esValido
    }

    // MARK: - Guardar (PATCH /reportes/:id)
    private func guardar() async {
        guard validarFormulario() else { return }

        guardando = true
        
        let cambios = DTOActualizarReporteRequest(
            nombre: nombre,
            descripcion: descripcion,
            fuenteId: fuenteId,
            tipoPropiedadId: tipoPropiedadId,
            tipoFraudeId: tipoFraudeId,
            precio: precioNumero,
            zona: zona.isEmpty ? nil : zona,
            contactoOfertante: contactoOfertante.isEmpty ? nil : contactoOfertante
        )
        
        do {
            _ = try await controladorReportes.actualizar(id: reporte.id, cambios: cambios)
            await vm.cargarTodo()
            dismiss()
        } catch {
            print("Error al guardar:", error)
            errorGeneral = "No se pudo guardar: \(error.localizedDescription)"
        }
        
        guardando = false
    }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Sección: Anuncio
                Section("Anuncio") {
                    VStack(alignment: .leading, spacing: 6) {
                        TextField("Título", text: $nombre)
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(errorNombre != nil ? Color.red : Color.clear, lineWidth: 1)
                            )
                        if let msg = errorNombre {
                            Text(msg)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    Picker("Plataforma", selection: $fuenteId) {
                            ForEach(vm.fuentes) { fuente in
                                Text(fuente.valorFuente).tag(fuente.id)
                            }
                        }
                        .pickerStyle(.menu)
                    
                    Picker("Tipo de propiedad", selection: $tipoPropiedadId) {
                            ForEach(vm.tiposPropiedad) { tipo in
                                Text(tipo.nombre).tag(tipo.id)
                            }
                        }
                        .pickerStyle(.menu)
                }

                // MARK: - Sección: ¿Qué sucedió?
                Section("¿Qué sucedió?") {
                    Picker("Tipo de fraude", selection: $tipoFraudeId) {
                            ForEach(vm.tiposFraude) { tipo in
                                Text(tipo.nombre).tag(tipo.id)
                            }
                        }
                        .pickerStyle(.menu)

                    VStack(alignment: .leading, spacing: 6) {
                        TextEditor(text: $descripcion)
                            .frame(minHeight: 120)
                            .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(errorDescripcion != nil ? Color.red : Color.clear, lineWidth: 1)
                            )
                        if let msg = errorDescripcion {
                            Text(msg)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }

                // MARK: - Sección: Datos adicionales
                Section("Datos adicionales (opcionales)") {
                    // Campo Precio
                    VStack(alignment: .leading, spacing: 6) {
                        TextField("Precio", text: $precio)
                            .keyboardType(.decimalPad)
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(errorPrecio != nil ? Color.red : Color.clear, lineWidth: 1)
                            )
                        if let msg = errorPrecio {
                            Text(msg)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    // Campo Zona
                    VStack(alignment: .leading, spacing: 6) {
                        TextField("Zona / Colonia", text: $zona)
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(errorZona != nil ? Color.red : Color.clear, lineWidth: 1)
                            )
                        if let msg = errorZona {
                            Text(msg)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    // Campo Contacto
                    VStack(alignment: .leading, spacing: 6) {
                        TextField("Contacto del ofertante", text: $contactoOfertante)
                            .keyboardType(.phonePad)
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(errorContacto != nil ? Color.red : Color.clear, lineWidth: 1)
                            )
                        if let msg = errorContacto {
                            Text(msg)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }

                // MARK: - Error de servidor
                if let errorGen = errorGeneral {
                    Section {
                        Text(errorGen)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
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
        // Usamos simultaneousGesture para no bloquear la interacción con los Pickers
        .simultaneousGesture(
            TapGesture().onEnded {
                ocultarTeclado()
            }
        )
    }
}
