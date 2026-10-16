//
//  ForgotPassTest.swift
//  ForgotPassTest
//
//  Created by alumno on 13/10/26.
//

import XCTest
@testable import _FraudStay_swiftUI_v1

final class ForgotPassTest: XCTestCase {
    
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
        XCTAssertTrue(correo.esVacio)
    }
    
    func testContrasenaLongitudValida() {
        let contrasena = "Marbella123!"
        XCTAssertTrue(contrasena.esLongitudValida)
    }
    
    func testContrasenaMuyCorta() {
        let contrasena = "Ab1!"
        XCTAssertFalse(contrasena.esLongitudValida)
    }
    
    func testContrasenaTieneMayuscula() {
        let contrasena = "Marbella123!"
        XCTAssertTrue(contrasena.tieneMayuscula)
    }
    
    func testContrasenaSinMayuscula() {
        let contrasena = "marbella123!"
        XCTAssertFalse(contrasena.tieneMayuscula)
    }
    
    func testContrasenaTieneMinuscula() {
        let contrasena = "MARBELLA123!"
        XCTAssertFalse(contrasena.tieneMinuscula)
    }
    
    func testContrasenaTieneNumero() {
        let contrasena = "Marbella123!"
        XCTAssertTrue(contrasena.tieneNumero)
    }
    
    func testContrasenaSinNumero() {
        let contrasena = "MarbellaHola!"
        XCTAssertFalse(contrasena.tieneNumero)
    }
    
    func testContrasenaTieneSimbolo() {
        let contrasena = "Marbella123!"
        XCTAssertTrue(contrasena.tieneSimbolo)
    }
    
    func testContrasenaSinSimbolo() {
        let contrasena = "Marbella1234"
        XCTAssertFalse(contrasena.tieneSimbolo)
    }
    
    func testContrasenaConTresCaracteresIguales() {
        let contrasena = "Marbellaaa123!"
        XCTAssertTrue(contrasena.tieneTresIgualesSeguidos)
    }
    
    func testContrasenaSinTresCaracteresIguales() {
        let contrasena = "Marbella123!"
        XCTAssertFalse(contrasena.tieneTresIgualesSeguidos)
    }
    
}
