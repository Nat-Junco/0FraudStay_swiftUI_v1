//
//  DTOCatalogos.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//

import Foundation

struct DTOFuente: Codable, Identifiable, Hashable {
    let id: Int
    let tipoFuente: String
    let valorFuente:String
}

struct DTOCatalogo: Codable, Identifiable, Hashable{
    let id: Int
    let nombre: String
}
