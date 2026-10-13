import SwiftUI

struct PrivacyView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Marca y paleta de colores
    private let rojoPrimary = Color("BrandPrimaryColor")
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header Informativo
                    VStack(alignment: .leading, spacing: 6) {
                        Text("0FRAUD STAY")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(rojoPrimary)
                            .tracking(1)
                        
                        Text("Aviso de Privacidad")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundStyle(.primary)
                        
                        Text("Última actualización: Octubre 2026")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 8)
                    
                }
                
                // Contenedor principal de Secciones
                VStack(alignment: .leading, spacing: 18) {
                    
                    seccionTexto(
                        titulo: "1. Responsable de la Protección de Datos",
                        contenido: "0FRAUD STAY es responsable del tratamiento de sus datos personales recolectados a través de esta aplicación móvil. Nos comprometemos a garantizar la confidencialidad y seguridad de su información conforme a la legislación aplicable."
                    )
                    
                    Divider()
                    
                    seccionTexto(
                        titulo: "2. Datos Personales que Recabamos",
                        contenido: "Para ofrecer nuestros servicios de prevención y reporte de fraudes en rentas vacacionales, recabamos:\n• Datos de identificación: Nombre completo y correo electrónico.\n• Datos de contacto e inicio de sesión.\n• Información sobre reportes: Ubicación general, descripción de hechos, evidencia adjunta y cuentas/plataformas señaladas en denuncias."
                    )
                    
                    Divider()
                    
                    seccionTexto(
                        titulo: "3. Finalidad del Tratamiento de Datos",
                        contenido: "Sus datos personales son utilizados para:\n• Autenticar y gestionar su cuenta de usuario.\n• Publicar, validar y dar seguimiento a reportes de fraude en la plataforma.\n• Enviar alertas preventivas de seguridad sobre incidentes reportados en su zona.\n• Mejorar continuamente la seguridad de la comunidad."
                    )
                    
                    Divider()
                    
                    seccionTexto(
                        titulo: "4. Protección e Identidad en los Reportes",
                        contenido: "Su nombre y correo electrónico nunca se publicarán abiertamente en los reportes comunitarios. Las denuncias visibles por otros usuarios resguardan la identidad del denunciante para garantizar su integridad y prevenir represalias."
                    )
                    
                    Divider()
                    
                    seccionTexto(
                        titulo: "5. Derechos ARCO",
                        contenido: "Usted tiene derecho a Acceder, Rectificar, Cancelar u Oponerse al tratamiento de sus datos personales. Puede ejercer estos derechos enviando una solicitud a través de la sección de Soporte en la app o editando su perfil directamente desde la configuración de su cuenta."
                    )
                }
                .padding(20)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                
                // Nota al pie
                HStack(spacing: 8) {
                    Image(systemName: "shield.fill")
                        .foregroundStyle(rojoPrimary)
                        .font(.system(size: 16))
                    
                    Text("Tus datos están protegidos mediante cifrado de extremo a extremo.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}
// Función para mostrar el texto
  @ViewBuilder
  private func seccionTexto(titulo: String, contenido: String) -> some View {
      VStack(alignment: .leading, spacing: 6) {
          Text(titulo)
              .font(.system(size: 15, weight: .bold))
              .foregroundStyle(.primary)
          
          Text(contenido)
              .font(.system(size: 13))
              .foregroundStyle(.secondary)
              .lineSpacing(3)
      }
  }

