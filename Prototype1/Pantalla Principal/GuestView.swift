import SwiftUI
import FirebaseAuth

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct CardView: View {
    var title: String
    var color: Color
            
    var body: some View {
        ZStack {
            color
                .cornerRadius(15)
                .shadow(color: .gray.opacity(0.5), radius: 8, x: 0, y: 5) // Sombra suave
            
            Text(title)
                .font(.title2)
                .foregroundColor(.white)
                .padding()
        }
        .frame(height: 150)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.5), lineWidth: 1) // Borde suave alrededor del botón
        )
    }
}

struct GuestView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var showDeleteAccountView = false
    
    var body: some View {
        ZStack {
            // Fondo con gradiente naranja más suave
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.orange]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    VStack(spacing: 25) { // Espaciado entre botones ajustado a 25
                        // Logo y botón de cerrar sesión
                        HStack {
                            Image("RED-BAMX")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            
                            Spacer()
                            
                            Menu {
                                Button(action: {
                                    // Acción para cerrar sesión
                                    viewModel.signOut()
                                }) {
                                    Text("Cerrar sesión")
                                    Image(systemName: "rectangle.portrait.and.arrow.right") // Icono para cerrar sesión
                                }
                                Button(action: {
                                    showDeleteAccountView = true
                                }) {
                                    Text("Eliminar cuenta")
                                    Image(systemName: "trash") // Icono para eliminar cuenta
                                }
                            } label: {
                                Label("Menu", systemImage: "ellipsis.circle")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Botón de Donar
                        NavigationLink(destination: ConocenosView().navigationBarBackButtonHidden(true)) {
                            CardView(title: "Conócenos", color: Color(hex: "#f94144")) // Rojo
                        }

                        // Botón de Calendario
                        NavigationLink(destination: CalendarView(authViewModel: viewModel).navigationBarBackButtonHidden(true)) {
                            CardView(title: "Calendario de eventos", color: Color(hex: "#f9844a")) // Naranja
                        }

                        
                        // Botón de Ubicación
                        NavigationLink(destination: PersonaView().navigationBarBackButtonHidden(true)) {
                            CardView(title: "Ubicaciones importantes", color: Color(hex:"#277da1")) // Azul
                        }
                        
                        // Botón de Reporte Ropa
                        NavigationLink(destination: ResiduoView().navigationBarBackButtonHidden(true)) {
                            CardView(title: "Donar Ropa", color: Color(hex: "#43aa8b")) // Verde
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Espaciado adicional para evitar que el último botón se corte
                    Spacer(minLength: 50)
                }
            }
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showDeleteAccountView) {
                DeleteAccountView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    // Crear un estado simulado para la vista previa
    @StateObject var viewModel = AuthenticationViewModel()
    return GuestView(viewModel: viewModel)
}
