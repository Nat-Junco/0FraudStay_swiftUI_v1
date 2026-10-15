//
//  EditProfileTest.swift
//  EditProfileTest
//
//  Created by alumno on 15/10/26.
//

import XCTest
@testable import _FraudStay_swiftUI_v1

final class EditProfileTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCorreoValido() {
            let correo = "ejemplo@gmail.com"
            XCTAssertTrue(correo.esCorreoValido)
        }
        
        func testCorreoInvalido() {
            let correo = "ejemplogmail.com"
            XCTAssertFalse(correo.esCorreoValido)
        }
        
        func testCorreoVacio() {
            let correo = ""
            XCTAssertFalse(correo.esCorreoValido)
        }
        
        func testNombreValido() {
            let nombre = "Adriana Sandoval"
            XCTAssertTrue(nombre.trimmingCharacters(in: .whitespaces).count >= 2)
        }
        
        func testNombreVacio() {
            let nombre = ""
            XCTAssertFalse(nombre.trimmingCharacters(in: .whitespaces).count >= 2)
        }
        
        func testNombreMuyCorto() {
            let nombre = "A"
            XCTAssertFalse(nombre.trimmingCharacters(in: .whitespaces).count >= 2)
        }
        
        func testNombreConEspacios() {
            let nombre = "   "
            XCTAssertFalse(nombre.trimmingCharacters(in: .whitespaces).count >= 2)
        }

}
