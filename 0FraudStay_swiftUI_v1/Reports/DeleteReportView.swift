
import SwiftUI

struct DeleteReportView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let rojoPrimary = Color("BrandPrimaryColor")
    var onDelete: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            
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
            Button(action: {
                dismiss()
            }) {
                Text("Cancelar")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .foregroundStyle(.black)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
        .background(Color(.secondarySystemGroupedBackground).ignoresSafeArea())
    }
}


#Preview {
    DeleteReportView()
}
