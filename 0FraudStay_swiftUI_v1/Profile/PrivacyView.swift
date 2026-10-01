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
                    
                }}}}}
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

