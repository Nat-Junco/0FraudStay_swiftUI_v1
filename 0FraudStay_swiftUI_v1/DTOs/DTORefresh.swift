//
//  DTORefresh.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 29/09/26.
//

import Foundation


struct DTORefreshRequest: Codable {
    let refreshToken: String
}

struct DTORefreshResponse: Codable {
    let accessToken: String
}


