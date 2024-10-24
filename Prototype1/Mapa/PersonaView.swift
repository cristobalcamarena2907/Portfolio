import SwiftUI
import MapKit

// Estructura Identificable para las coordenadas con nombre y descripción
struct Location: Identifiable {
    let id = UUID() // Genera un ID único para cada instancia
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
}

struct PersonaView: View {
    let donationPoints = [
        Location(
            name: "Banco de Alimentos Guadalajara",
            description: "Se pueden donar alimentos no perecederos, excedentes alimenticios, ropa y realizar donaciones económicas.",
            coordinate: CLLocationCoordinate2D(latitude: 20.6189, longitude: -103.3081)
        ),
        Location(
            name: "Universidad Autónoma de Guadalajara (UAG)",
            description: "Donaciones de alimentos no perecederos y participación en programas como 'Uniendo Manos', que apadrina despensas para familias vulnerables.",
            coordinate: CLLocationCoordinate2D(latitude: 20.6747, longitude: -103.3878)
        ),
        Location(
            name: "Catedral Metropolitana de Guadalajara",
            description: "Aceptan donaciones de alimentos no perecederos durante eventos y colectas especiales.",
            coordinate: CLLocationCoordinate2D(latitude: 20.6765, longitude: -103.3470)
        ),
        Location(
            name: "Instituto Tecnológico y de Estudios Superiores de Occidente (ITESO)",
            description: "Recogen alimentos no perecederos a través de campañas organizadas por la comunidad estudiantil.",
            coordinate: CLLocationCoordinate2D(latitude: 20.6146, longitude: -103.3270)
        ),
        Location(
            name: "Plaza Galerías Guadalajara",
            description: "Espacios habilitados para colectas de alimentos no perecederos durante eventos comunitarios.",
            coordinate: CLLocationCoordinate2D(latitude: 20.6614, longitude: -103.3915)
        )
    ]
    
    @Environment(\.dismiss) var dismiss
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20.659698, longitude: -103.349609),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @State private var selectedLocation: Location? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo degradado
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.orange]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Encabezado con logo
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("RED-BAMX")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .shadow(radius: 5)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            Text("Puntos de Donación")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .bold()
                                .padding(.bottom, 10)
                                .multilineTextAlignment(.center)
                            
                            // Mapa con fondo semitransparente
                            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, annotationItems: donationPoints) { point in
                                MapAnnotation(coordinate: point.coordinate) {
                                    VStack(spacing: 5) {
                                        Text(point.name)
                                            .font(.caption)
                                            .foregroundColor(.black)
                                            .padding(5)
                                            .background(Color.white.opacity(0.8))
                                            .cornerRadius(5)
                                        
                                        Button(action: {
                                            selectLocation(point)
                                        }) {
                                            Image(systemName: "mappin.and.ellipse")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(.red)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            .frame(width: 350, height: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.6), lineWidth: 2))
                            .background(Color.white.opacity(0.7)) // Fondo semitransparente
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            
                            if let location = selectedLocation {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(location.name)
                                        .font(.title2)
                                        .foregroundColor(.black)
                                        .bold()
                                    
                                    Text(location.description)
                                        .font(.body)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom, 10) // Más espacio debajo del texto
                                    
                                    Button(action: {
                                        openMaps(for: location)
                                    }) {
                                        Text("Viajar a ubicación")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.green) // Verde del logo
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.85)) // Fondo más suave
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.horizontal)
                            } else {
                                Text("Selecciona un punto en el mapa para ver su descripción.")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                    .background(Color.white.opacity(0.8)) // Fondo semitransparente
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                                    .padding(.bottom, 20)
                            }
                        }
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Regresar")
                            .font(.title2)
                            .foregroundColor(.orange) // Texto naranja
                            .padding()
                            .frame(width: 250, height: 50)
                            .background(Color.white) // Fondo blanco
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)
                }
                .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    private func selectLocation(_ location: Location) {
        selectedLocation = location
        withAnimation {
            region.center = location.coordinate
        }
    }
    
    private func openMaps(for location: Location) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let regionDistance: CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        mapItem.openInMaps(launchOptions: options)
    }
}

#Preview {
    PersonaView()
}
