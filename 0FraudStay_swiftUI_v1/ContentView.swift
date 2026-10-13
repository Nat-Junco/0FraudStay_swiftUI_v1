import SwiftUI

struct ContentView: View {
    @State private var mostrandoSplash = true
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    var body: some View {
        ZStack {
            if mostrandoSplash {
                WelcomeView()
            } else if isLoggedIn {
                StartView()
            } else {
                LogInView()
            }
        }
        .task {
            isLoggedIn = false
            
            // Espera de 4 segundos para el WelcomeView
            try? await Task.sleep(for: .seconds(4))
            
            withAnimation(.easeInOut) {
                mostrandoSplash = false
            }
        }
    }
}
