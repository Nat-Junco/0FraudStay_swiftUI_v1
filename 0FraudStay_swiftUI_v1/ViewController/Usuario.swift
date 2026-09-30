//
//  Usuario.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumnos on 30/09/26.
//

import Foundation

extension RegisterView{
    struct Usuario{
        var nombre:String = ""
        var correo:String = ""
        var password:String = ""
        var confirmarPassword:String = ""
        
        func validarDatos() -> [String] {
            var errores: [String] = []
            if nombre.trimmingCharacters(in: .whitespaces).count < 2 {
                errores.append("Debes de ingresar tu nombre (mínimo de 2 caracteres) ")
            }
            if correo.esVacio {
                errores.append("Debes ingresar un correo")
            } else if !correo.esCorreoValido {
                errores.append("Debes ingresar un correo válido")
            }
            if password.esVacio {
                errores.append("Debes ingresar una contraseña")
            } else {
                if !password.esLongitudValida{
                    errores.append("La contraseña debe tener al menos 10 caracteres")
                }
                if !password.tieneMayuscula {
                    errores.append("La contraseña debe tener al menos una mayúscula")
                }
                if !password.tieneMinuscula{
                    errores.append("La contraseña debe tener al menos una minúscula")
                }
                if !password.tieneNumero {
                    errores.append("La contraseña debe tener al menos un número")
                }
                if !password.tieneSimbolo{
                    errores.append("La contraseña debe tener al menos un símbolo")
                }
                if !password.tieneTresIgualesSeguidos {
                    errores.append("La contraseña no puede tener tres caracteres iguales seguidos")
                }
            }
            if password != confirmarPassword{
                errores.append("Las contraseñas no coinciden")
            }
            return errores
        }
        
    }
}


