import SwiftUI

struct ContentView: View {
    @State private var mostrandoSplash = true
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    
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
            isLoggedIn = true
            
            try? await Task.sleep(for: .seconds(4))
            
            withAnimation(.easeInOut) {
                mostrandoSplash = false
            }
        }
    }
}
