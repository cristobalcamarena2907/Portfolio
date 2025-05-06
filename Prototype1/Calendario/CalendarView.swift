import SwiftUI

struct CalendarView: View {
    @StateObject var viewModel = EventViewModel()
    var authViewModel: AuthenticationViewModel // Para obtener el usuario autenticado
    @Environment(\.dismiss) var dismiss
    
    @State private var idToDelete = ""
    
    var body: some View {
        ZStack {
            // Fondo con gradiente similar al resto de las vistas
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.orange]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Encabezado con logo, título y botón de añadir evento (solo para admin)
                HStack {
                    Button(action: {
                        dismiss() // Regresar al menú anterior
                    }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.orange)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    Spacer()
                    
                    Image("RED-BAMX")  // Coloca tu imagen del logo aquí
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    
                    Spacer()
                    
                    // Verificamos si el usuario es administrador para mostrar el botón de añadir evento
                    if authViewModel.isAdmin() {
                        NavigationLink(destination: AddEventView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "plus.circle")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    }
                }
                .padding()
                
                Text("Eventos")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.bottom, 10)

                // Lista de eventos
                ScrollView {
                    ForEach(viewModel.events) { event in
                        VStack(alignment: .leading) {
                            Text(event.title)
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.bottom, 5)
                            
                            Text("Fecha: \(event.date, formatter: eventDateFormatter)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            /*Text("Ubicación: \(event.location.latitude), \(event.location.longitude)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            if let imageUrl = event.imageUrl {
                                AsyncImage(url: URL(string: imageUrl)) { image in
                                    image.resizable().scaledToFit().frame(height: 150)
                                } placeholder: {
                                    ProgressView()
                                }
                            }*/
                            
                            Text("Dirección: \(event.address)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            if let url = URL(string: event.link), UIApplication.shared.canOpenURL(url) {
                                Link(destination: url) {
                                    Text(event.link)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                        .underline() // Opción para subrayar el texto y hacerlo más evidente
                                    }
                                } else {
                                    Text(event.link)
                                        .font(.subheadline)
                                        .foregroundColor(.gray) // El link no es válido, lo muestra en gris
                            }
                            
                            Text(event.description)
                                .font(.body)
                                .foregroundColor(.black)
                                .padding(.top, 5)
                                .multilineTextAlignment(.center)
                            
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                }
                .onAppear {
                    viewModel.fetchEvents()
                }
                
                // Botón para eliminar evento por ID
                TextField("ID del evento a eliminar", text: $idToDelete)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)

                Button(action: {
                    viewModel.deleteEvent(withID: idToDelete) // Aquí se usa la función para eliminar
                }) {
                    Text("Eliminar Evento")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
            }
        }
    }
}

let eventDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    CalendarView(authViewModel: AuthenticationViewModel())
}
