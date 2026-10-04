
import SwiftUI

struct DeleteReportSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let rojoPrimary = Color("BrandPrimaryColor")
    var onDelete: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 36, height: 5)
                .padding(.top, 12)
            
            ZStack {
                Circle()
                    .fill(rojoPrimary.opacity(0.08))
                    .frame(width: 56, height: 56)
                
                Image(systemName: "trash")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(rojoPrimary)
            }
            .padding(.top, 8)
            VStack(spacing: 8) {
                Text("¿Eliminar reporte?")
                    .font(.system(size: 22, weight: .bold, design: .serif))
                    .foregroundStyle(.primary)
                
                Text("Esta acción no se puede deshacer. Solo puedes eliminar reportes que aún no han sido validados.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 24)
            
            Spacer().frame(height: 10)
            
            // Botón Principal: Eliminar
            Button(action: {
                onDelete?()
                dismiss()
            }) {
                Text("Sí, eliminar reporte")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(rojoPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 20)
            
        }}}

#Preview {
    DeleteReportSheetView()
}
