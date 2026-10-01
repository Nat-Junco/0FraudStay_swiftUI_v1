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
                        Text("OFRAUD STAY")
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
