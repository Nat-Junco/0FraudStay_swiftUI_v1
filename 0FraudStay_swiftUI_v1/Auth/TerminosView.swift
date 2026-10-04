import SwiftUI

struct TermsView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let rojoPrimary = Color("BrandPrimaryColor")
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("0FRAUD STAY")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(rojoPrimary)
                            .tracking(1)
                        
                        Text("Términos y Condiciones")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundStyle(.primary)
                        
                        Text("Última actualización: Octubre 2026")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 8)
                    VStack(alignment: .leading, spacing: 18) {
                        
                        seccionTexto(
                            titulo: "1. Aceptación de los Términos",
                            contenido: "Al descargar, acceder o utilizar la aplicación OFRAUD STAY, aceptas quedar vinculado por los presentes Términos y Condiciones. Si no estás de acuerdo con alguno de los puntos, te pedimos abstenerte de utilizar la plataforma."
                        )
                        
                        Divider()
                        
                        seccionTexto(
                            titulo: "2. Uso de la Plataforma y Registro",
                            contenido: "OFRAUD STAY es una herramienta comunitaria orientada a la prevención e identificación de fraudes en rentas vacacionales. Para publicar reportes o interactuar con la plataforma, debes registrarte proporcionando información verídica y mantener la confidencialidad de tus credenciales de acceso."
                        )
                        
                        Divider()
                        
                        seccionTexto(
                            titulo: "3. Publicación de Reportes y Contenido",
                            contenido: "Al emitir una alerta o denuncia, declaras que los hechos expuestos son reales y que actúas de buena fe. Queda estrictamente prohibido:\n• Publicar información falsa, engañosa o difamatoria.\n• Compartir datos personales sensibles de terceros no involucrados.\n• Utilizar lenguaje de odio, ofensivo o promocionar servicios no autorizados."
                        )
                        
                        Divider()
                        
                        seccionTexto(
                            titulo: "4. Moderación y Responsabilidad del Contenido",
                            contenido: "OFRAUD STAY actúa como un canal de colaboración ciudadana. Aunque implementamos filtros de moderación, no nos hacemos responsables por la precisión de la información compartida directamente por los usuarios ni por transacciones externas celebradas entre terceros."
                        )
                        
                        Divider()
                        
                        seccionTexto(
                            titulo: "5. Cancelación y Modificaciones",
                            contenido: "Nos reservamos el derecho de suspender o eliminar cuentas que infrinjan estas normas, así como de actualizar estos Términos y Condiciones en cualquier momento para adaptarlos a mejoras continuas en la plataforma o cambios legislativos."
                        )
                    }
                    .padding(20)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    
                }}}}}
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


#Preview {
    TermsView()
}
