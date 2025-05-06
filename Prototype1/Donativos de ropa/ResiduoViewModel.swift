
import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseStorage
import UIKit
import CoreLocation

class DonateClothesViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var descriptionClothes: String = ""
    @Published var contactInfo: String = ""
    @Published var location: CLLocation?
    @Published var image: UIImage?
    @Published var showImagePicker: Bool = false
    @Published var locationStatus: String = "Esperando ubicación..."
    
    private var locationManager: CLLocationManager?
    private let firebaseService = FirebaseService()

    override init() {
        super.init()
        setupLocationManager()  // Asegúrate de que este método sea llamado en el inicializador.
    }

    // Este es el método que falta
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        locationStatus = "Solicitando ubicación..."
        switch locationManager?.authorizationStatus {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationStatus = "Acceso a la ubicación denegado. Por favor, habilite el acceso en la configuración."
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.requestLocation()
        default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager?.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            locationStatus = "Ubicación obtenida"
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación: \(error.localizedDescription)")
        locationStatus = "Error al obtener la ubicación. Intente nuevamente."
    }

    func sendDonation() {
        firebaseService.sendClothDonation(
            descriptionClothes: descriptionClothes,
            contactInfo: contactInfo,
            location: location,
            image: image
        ) { error in
            if let error = error {
                print("Error al enviar la donación: \(error.localizedDescription)")
            } else {
                print("Donación enviada con éxito")
            }
        }
    }
}

