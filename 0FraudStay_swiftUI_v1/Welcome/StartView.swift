import SwiftUI

enum Tab {
    case inicio
    case reportes
    case crear
    case guides
    case perfil
}

struct StartView: View {
    
    @State private var selectedTab: Tab = .inicio
    
    private let rojo = Color("BrandPrimaryColor")
    private let verde = Color("VerificateColor")
    private let fondo = Color("FondoApp")
    private let borde = Color("Border")
    private let textoPrincipal = Color(.black)
    private let textoGris = Color(.lightGray)
    
    @StateObject private var vm = ReportesViewModel()
    @State private var reporteAEditar: DTOReporteResponse?
    @State private var reporteAEliminar: DTOReporteResponse?
    
    @State private var mostrarAlertaError = false

    private var misReportesEditables: [DTOReporteResponse] {
        Array(vm.mios.filter { $0.esEditable }.prefix(3))
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            
            pantallaInicio
                .tabItem {
                    Label("Inicio", systemImage: "house")
                }
                .tag(Tab.inicio)
            
            NavigationStack {
                AllReportsView()
            }
            .tabItem {
                Label("Reportes", systemImage: "exclamationmark.triangle")
            }
            .tag(Tab.reportes)
            
            NavigationStack {
                CreateReportView()
            }
            .tabItem {
                Label("Crear", systemImage: "plus.app.fill")
            }
            .tag(Tab.crear)
            
            NavigationStack {
                GuidesView()
            }
            .tabItem {
                Label("Guías", systemImage: "book")
            }
            .tag(Tab.guides)
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Perfil", systemImage: "person")
            }
            .tag(Tab.perfil)
        }
        .tint(.red)
        .environmentObject(vm)
        .task {
            await vm.cargarTodo()
        }
    }
    
    private var pantallaInicio: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                fondo
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Encabezado
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("0FRAUD STAY")
                                    .font(.system(size: 12, weight: .bold))
                                    .kerning(1.2)
                                    .foregroundStyle(rojo)
                                Text("Inicio")
                                    .font(.system(size: 26, weight: .bold, design: .serif))
                                    .foregroundStyle(textoPrincipal)
                            }
                            Spacer()
                            Image("appLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .background(fondo)
                        }
                        .padding(.top, 8)
                        
                        
                        // Guías de seguridad
                        NavigationLink {
                            GuidesView()
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: "book.closed.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(verde)
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Guías de seguridad")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(textoPrincipal)
                                    Text("Plataformas verificadas y consejos antifraude")
                                        .font(.system(size: 12))
                                        .foregroundStyle(textoGris)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(verde)
                            }
                            .padding(16)
                            .background(verde.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(verde.opacity(0.25), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        
                        // Botones Denunciar y consultar
                        HStack(spacing: 12) {
                            NavigationLink {
                                CreateReportView()
                            } label: {
                                VStack(spacing: 10) {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundStyle(.white)
                                    
                                    Text("Denunciar")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 106)
                                .background(rojo)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink {
                                AllReportsView()
                            } label: {
                                VStack(spacing: 10) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundStyle(textoPrincipal)
                                    
                                    Text("Consultar")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(textoPrincipal)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 106)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(borde, lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        
                        // Mis reportes
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Mis reportes")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(textoPrincipal)
                                Spacer()
                                NavigationLink {
                                    MyReportsView()
                                } label: {
                                    Text("Ver más →")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(rojo)
                                }
                            }
                            Text("Reportes 'Pendientes' o 'En revisión' son editables hasta que el admin los valide")
                                .font(.system(size: 13))
                                .foregroundStyle(textoGris)
                        }
                        .padding(.top, 8)
                        
                        if misReportesEditables.isEmpty {
                            Text(vm.isLoading ? "Cargando..." : "No tienes reportes")
                                .font(.system(size: 14))
                                .foregroundStyle(textoGris)
                        } else {
                            ForEach(misReportesEditables) { reporte in
                                VStack(alignment: .leading, spacing: 14) {
                                    HStack(alignment: .top, spacing: 14) {
                                        Image(systemName: "clock.fill")
                                            .renderingMode(.template)
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundStyle(reporte.colorEstado)
                                            .frame(width: 48, height: 48)
                                            .background(reporte.colorEstado.opacity(0.1))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))

                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(reporte.nombre)
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundStyle(textoPrincipal)
                                                .fixedSize(horizontal: false, vertical: true)
                                            Text("\(vm.nombreFuente(reporte.fuenteId)) · \(reporte.fecha)")
                                                .font(.system(size: 14))
                                                .foregroundStyle(textoGris)
                                            Text("RS-\(String(format: "%04d", reporte.id))")
                                                .font(.system(size: 12, design: .monospaced))
                                                .foregroundStyle(textoGris)
                                        }

                                        Spacer(minLength: 4)

                                        Text(reporte.nombreEstado)
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundStyle(reporte.colorEstado)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(reporte.colorEstado.opacity(0.12))
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                    }

                                    HStack(spacing: 10) {
                                        Button {
                                            reporteAEditar = reporte
                                        } label: {
                                            HStack(spacing: 6) {
                                                Image(systemName: "square.and.pencil")
                                                    .renderingMode(.template)
                                                    .font(.system(size: 14, weight: .semibold))
                                                
                                                Text("Editar")
                                                    .font(.system(size: 14, weight: .semibold))
                                            }
                                            .foregroundStyle(textoPrincipal)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 38)
                                            .background(fondo)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(borde, lineWidth: 1)
                                            )
                                        }

                                        Button {
                                            reporteAEliminar = reporte
                                        } label: {
                                            HStack(spacing: 6) {
                                                Image(systemName: "trash")
                                                    .renderingMode(.template)
                                                    .font(.system(size: 14, weight: .semibold))
                                                
                                                Text("Eliminar")
                                                    .font(.system(size: 14, weight: .semibold))
                                            }
                                            .foregroundStyle(rojo)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 38)
                                            .background(rojo.opacity(0.06))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(rojo.opacity(0.25), lineWidth: 1)
                                            )
                                        }
                                    }
                                    .padding(.leading, 62)
                                }
                                .padding(18)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(borde, lineWidth: 1)
                                )
                            }
                        }

                        // Reportes recientes
                        HStack {
                            Text("Reportes recientes")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(textoPrincipal)
                            Spacer()
                            NavigationLink {
                                AllReportsView()
                            } label: {
                                Text("Ver todos →")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(rojo)
                            }
                        }
                        .padding(.top, 8)

                        // Reportes de la comunidad
                        if vm.verificadosRecientes.isEmpty {
                            Text(vm.isLoading ? "Cargando…" : "Aún no hay reportes aprobados")
                                .font(.system(size: 14))
                                .foregroundStyle(textoGris)
                        } else {
                            ForEach(vm.verificadosRecientes) { reporte in
                                NavigationLink {
                                    ReportDetailView(reporte: reporte)
                                } label: {
                                    VStack(alignment: .leading, spacing: 12) {
                                        ZStack(alignment: .top) {
                                            AsyncImage(url: reporte.fotoURLCompleta) { fase in
                                                if let imagen = fase.image {
                                                    imagen
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                } else {
                                                    Rectangle().fill(borde)
                                                }
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 150)
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: 12))

                                            HStack {
                                                Text(reporte.nombreEstado)
                                                    .font(.system(size: 11, weight: .bold))
                                                    .foregroundStyle(reporte.colorEstado)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(Color.white.opacity(0.9))
                                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                                Spacer()
                                            }
                                            .padding(10)
                                        }

                                        Text(reporte.nombre)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(textoPrincipal)
                                            .multilineTextAlignment(.leading)

                                        HStack {
                                            Text(vm.nombreFuente(reporte.fuenteId))
                                            Spacer()
                                            Text(vm.nombreTipoPropiedad(reporte.tipoPropiedadId))
                                        }
                                        .font(.system(size: 13))
                                        .foregroundStyle(textoGris)

                                        HStack(spacing: 8) {
                                            Text(vm.nombreTipoFraude(reporte.tipoFraudeId))
                                                .font(.system(size: 11, weight: .medium))
                                                .foregroundStyle(textoGris)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(fondo)
                                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                            Spacer()
                                            Text(reporte.fecha)
                                        }
                                        .font(.system(size: 12))
                                        .foregroundStyle(textoGris)
                                    }
                                    .padding(14)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(borde, lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    .padding(.top, 10)
                }
            }
        }
        .sheet(item: $reporteAEditar) { reporte in
            EditReportView(reporte: reporte)
                .environmentObject(vm)
        }
        .sheet(item: $reporteAEliminar) { reporte in
            DeleteReportView(onDelete: {
                Task { await vm.eliminar(reporte) }
            })
            .presentationDetents([.height(340)])
        }
    }
}
