import SwiftUI
import CoreLocation

struct AddEventView: View {
    @State private var id = ""
    @State private var title = ""
    @State private var date = Date()
    @State private var description = ""
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var selectedImage: UIImage?
    @State private var link = ""
    @State private var address = ""
    @StateObject private var viewModel = EventViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Fondo degradado similar a las otras vistas
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.orange]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Encabezado con logo, botón de regresar
                HStack {
                    Button(action: {
                        dismiss() // Regresar al calendario
                    }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.orange)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    Spacer()
                    
                    Image("RED-BAMX") // Coloca tu imagen del logo aquí
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    
                    Spacer()
                }
                .padding()

                Text("Añadir Evento")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                
                // Campos para añadir un nuevo evento
                ScrollView {
                    VStack(spacing: 20) {
                        
                        HStack {
                            
                            TextField("ID", text: $id)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            
                            TextField("Título del evento", text: $title)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        
                        DatePicker("Fecha del evento", selection: $date)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        HStack {
                            TextField("Latitud", text: $latitude)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            
                            TextField("Longitud", text: $longitude)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        
                        TextField("Dirección", text: $address)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        TextField("Link al evento", text: $link)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        TextField("Descripción del evento", text: $description)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        // Botón para subir una imagen
                        /*Button(action: {
                            // Implementar lógica para seleccionar una imagen
                        }) {
                            Text("Subir Imagen")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        
                        // Imagen seleccionada (si existe)
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }*/

                        // Botón para guardar el evento
                        Button(action: {
                            // Validar y procesar los valores de latitud y longitud
                            guard let lat = Double(latitude), let lon = Double(longitude) else {
                                // Muestra un mensaje de error si los valores no son válidos
                                print("Latitud o longitud no válidas")
                                return
                            }

                            viewModel.addEvent(
                                id: id,
                                title: title,
                                date: date,
                                location: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                description: description,
                                image: selectedImage,
                                link: link,
                                address: address
                            )
                            dismiss()
                        }) {
                            Text("Guardar Evento")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

// Para la vista previa, usar @ObservedObject para evitar el crash
#Preview {
    AddEventView()
}
