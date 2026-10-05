//
//  ResumenErrores.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 30/09/26.
//

import SwiftUI

struct ResumenErrores: View {
    var errores: [String] = []
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(errores, id: \.self){ error in
                Text(". \(error)")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .frame(maxWidth:.infinity, alignment: .leading)
    }
    
}

#Preview {
    ResumenErrores(errores: ["La contraseña es vacia ", "Error 2"])
}


