//
//  TokenStorage+JWT.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 06/10/26.
//

import Foundation

extension TokenStorage{
    static func payloadDelToken() -> [String: Any]? {
        guard let token = get (identifier: "accessToken") else {return nil}
        let partes = token.split(separator: ".")
        guard partes.count == 3 else {return nil}
        
        var base64 = String (partes[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while base64.count % 4 != 0 {base64 += "="}
        guard let data = Data(base64Encoded: base64),
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return json
    }
    
    static func usuarioIdDelToken() -> String? {
        payloadDelToken()?["sub"] as? String
    }
}
