//
//  StartView.swift
//  0FraudStay_swiftUI_v1
//
//  Created by alumno on 23/09/26.
//

import SwiftUI

enum Tab {
    case inicio
    case reportes
    case crear
    case dashboard
    case perfil
}

struct StartView: View {
    @State private var selectedTab: Tab = .inicio
    @State private var showCreateReport = false

    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                VStack {
    
                    Text("Pantalla de Inicio")
                        .font(.title)
                }
                .navigationTitle("Inicio")
            }
            .tabItem {
                Label("Inicio", systemImage: "house")
            }
            .tag(Tab.inicio)
            
            
            NavigationStack {
                ReportsView()
            }
            .tabItem {
                Label("Reportes", systemImage: "exclamationmark.triangle")
            }
            .tag(Tab.reportes)
            
            NavigationStack {
                CreateReportView()
            }
            .tabItem {
                Label(".", systemImage: "plus.app.fill")
            }
            .tag(Tab.reportes)

            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("Dashboard", systemImage: "square.grid.2x2")
            }
            .tag(Tab.dashboard)
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Perfil", systemImage: "person")
            }
            .tag(Tab.perfil)
        }
        .tint(.red)
    }
}

#Preview {
    StartView()
}
