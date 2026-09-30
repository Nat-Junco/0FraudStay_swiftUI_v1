//
//  DTOLogin.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//

import Foundation


// MARK: - DTOLoginRequest
class DTOLoginRequest: Codable {
    var email, password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

// MARK: - DTOLoginResponse
class DTOLoginResponse: Codable {
    var accessToken, refreshToken: String

    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

