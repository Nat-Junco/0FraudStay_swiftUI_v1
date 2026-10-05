//
//  VariablesAmbiente.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var authController = ControladorRegistroUsuario(httpClient: HTTPClient())
    @Entry var reportesController = ControladorReportes(httpClient: HTTPClient())
}


