//
//  ValidarDatosRegistro.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//

import Foundation

extension String {
    var esVacio: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var esCorreoValido: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return self.range(of: emailRegEx, options: .regularExpression) != nil
    }
    // @MinLength(10)
    var esLongitudValida: Bool { count >= 10 }
    // @Matches(/[A-Z]/)
    var tieneMayuscula: Bool { range(of: "[A-Z]", options: .regularExpression) != nil }
    // @Matches(/[a-z]/)
    var tieneMinuscula: Bool { range(of: "[a-z]", options: .regularExpression) != nil }
    // @Matches(/[0-9]/)
    var tieneNumero: Bool { range(of: "[0-9]", options: .regularExpression) != nil }
    // @Matches(/[^A-Za-z0-9]/)
    var tieneSimbolo: Bool { range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil }
    // @Matches(/^(?!.*(.)\1\1)/)
    var tieneTresIgualesSeguidos: Bool { range(of: "(.)\\1\\1", options: .regularExpression) != nil }
}


