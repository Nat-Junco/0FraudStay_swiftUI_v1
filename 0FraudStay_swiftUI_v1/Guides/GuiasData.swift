//
//  GuiasData.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 30/09/26.
//

import Foundation

// MARK: - Modelos
// Son Codable para que después se puedan leer directo del archivo de guías de la BD (JSON).

struct VerifiedPlatforms: Codable, Identifiable {
    let id: Int
    let nombre: String
    let url: String
    let logo: String   // nombre de la imagen del logo en Assets
}

struct TipAntifraude: Codable, Identifiable {
    let id: Int
    let emoji: String
    let titulo: String
    let descripcion: String
}

// MARK: - Datos fijos de las guías
// Estos datos NO dependen de los reportes de usuarios.
// Cuando conecten la BD, reemplacen estas listas por lo que venga del archivo de guías.
enum GuiasData {

    static let platforms: [VerifiedPlatforms] = [
        VerifiedPlatforms(id: 1, nombre: "Airbnb",      url: "https://www.airbnb.mx",   logo: "logoAirbnb"),
        VerifiedPlatforms(id: 2, nombre: "Booking.com", url: "https://www.booking.com", logo: "logoBooking"),
        VerifiedPlatforms(id: 3, nombre: "Vrbo",        url: "https://www.vrbo.com",    logo: "logoVrbo"),
        VerifiedPlatforms(id: 4, nombre: "Expedia",     url: "https://www.expedia.mx",  logo: "logoExpedia")
    ]

    static let tips: [TipAntifraude] = [
        TipAntifraude(id: 1, emoji: "💳", titulo: "Paga solo dentro de la plataforma",
            descripcion: "Si el anfitrión te pide transferencia, depósito o pago por WhatsApp, es la señal de fraude más común. Fuera de la plataforma no hay protección ni reembolso."),
        TipAntifraude(id: 2, emoji: "💸", titulo: "Desconfía de precios muy bajos",
            descripcion: "Compara con propiedades parecidas en la misma zona. Un precio muy por debajo del promedio suele ser el anzuelo."),
        TipAntifraude(id: 3, emoji: "🔍", titulo: "Busca las fotos en internet",
            descripcion: "Usa la búsqueda por imagen de Google o Google Lens. Si las fotos aparecen en otro anuncio, otra ciudad o una inmobiliaria, probablemente son robadas."),
        TipAntifraude(id: 4, emoji: "📹", titulo: "Pide una videollamada",
            descripcion: "Pide al anfitrión que te muestre la propiedad en vivo, incluyendo la fachada y la calle. Si pone excusas, desconfía."),
        TipAntifraude(id: 5, emoji: "⭐", titulo: "Revisa el perfil y las reseñas",
            descripcion: "Cuentas nuevas, sin reseñas o con reseñas muy parecidas entre sí son de alto riesgo. Verifica que el nombre coincida con el de quien recibe el pago."),
        TipAntifraude(id: 6, emoji: "⏰", titulo: "No cedas ante la urgencia",
            descripcion: "Frases como \"hay otra persona interesada\" o \"la oferta vence hoy\" buscan que pagues sin pensar."),
        TipAntifraude(id: 7, emoji: "🔄", titulo: "Cuidado con los cambios de último minuto",
            descripcion: "Si justo antes de llegar te cambian la propiedad, la dirección o el método de pago, detén todo y confirma con la plataforma."),
        TipAntifraude(id: 8, emoji: "🛡️", titulo: "Consulta 0Fraud Stay antes de pagar",
            descripcion: "Busca la dirección, el anfitrión o el anuncio en los reportes de la comunidad y en las propiedades verificadas.")
    ]
}
