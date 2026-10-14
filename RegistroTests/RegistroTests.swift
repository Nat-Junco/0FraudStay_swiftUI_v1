//
//  RegistroTests.swift
//  RegistroTests
//
//  Created by alumnos on 13/10/26.
//

import XCTest
@testable import _FraudStay_swiftUI_v1

final class RegistroTests: XCTestCase {

    //Nombre
    
    func testCampoVacio(){
        XCTAssertTrue("".esVacio)
    }
    
    func testCampoSoloEspacios(){
        XCTAssertTrue("     ".esVacio)
    }
    
    func testCampoConTexto(){
        XCTAssertFalse("Ara".esVacio)
    }
    
    //Correo
    
    func testCorreoValido(){
        XCTAssertTrue("ara@tec.mx".esCorreoValido)
    }
    
    func testCorreoSinArroba(){
        XCTAssertFalse("aratec.mx".esCorreoValido)
    }
    
    func testCorreoSinDominio(){
        XCTAssertFalse("ara@tec".esCorreoValido)
    }
    
    //Contrasena
    
    func testContrasenaCorta(){
        XCTAssertFalse("Fraude#26" .esLongitudValida)
    }
    
    func testContrasena10Char(){
        XCTAssertTrue("Fraude#2026" .esLongitudValida)
    }
    
    func testContrasenaSinMayuscula(){
        XCTAssertFalse("fraude#2026".tieneMayuscula)
    }
    
    func testContrasenaConMayuscula(){
        XCTAssertTrue("Fraude#2026".tieneMayuscula)
    }
    
    func testContrasenaSinMinuscula(){
        XCTAssertFalse("FRAUDE#2026".tieneMinuscula)
    }
    
    func testContrasenaConMinuscula(){
        XCTAssertTrue("FRAUDe#2026".tieneMinuscula)
    }
    
    func testContrasenaSinNumero(){
        XCTAssertFalse("Fraude#fraude".tieneNumero)
    }
    
    func testContrasenaConNumero(){
        XCTAssertTrue("Fraude#fraud3".tieneNumero)
    }
    
    func testContrasenaSinSimbolo(){
        XCTAssertFalse("Fraude2026".tieneSimbolo)
    }
    
    func testContrasenaConSimbolo(){
        XCTAssertTrue("Fraude/2026".tieneSimbolo)
    }
    
    func testContrasenaConTresIguales(){
        XCTAssertTrue("Fraude#111".tieneTresIgualesSeguidos)
    }
    
    func testContrasenaSinTresIguales(){
        XCTAssertFalse("Fraude#123".tieneTresIgualesSeguidos)
    }
    
    func testContrasenaValida(){
        let contrasena = "Fraude//2026"
        XCTAssertTrue(contrasena.esLongitudValida)
        XCTAssertTrue(contrasena.tieneMayuscula)
        XCTAssertTrue(contrasena.tieneMinuscula)
        XCTAssertTrue(contrasena.tieneNumero)
        XCTAssertTrue(contrasena.tieneSimbolo)
        XCTAssertFalse(contrasena.tieneTresIgualesSeguidos)
    }
    

}
