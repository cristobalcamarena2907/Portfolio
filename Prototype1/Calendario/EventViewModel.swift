import Foundation
import FirebaseFirestore
import CoreLocation
import SwiftUI

struct Event: Identifiable {
    let id: String
    let title: String
    let date: Date
    let location: CLLocationCoordinate2D
    let description: String
    let imageUrl: String?
    let link: String
    let address: String
}

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    private let eventService = EventService()
    
    // Obtener eventos
    func fetchEvents() {
        eventService.getEvents { events, error in
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                return
            }
            self.events = events
        }
    }
    
    // Guardar nuevo evento
    func addEvent(id: String, title: String, date: Date, location: CLLocationCoordinate2D, description: String, image: UIImage?, link: String, address: String) {
        eventService.saveEvent(id: id, title: title, date: date, location: location, description: description, image: image, link: link, address: address) { error in
            if let error = error {
                print("Error saving event: \(error.localizedDescription)")
            } else {
                self.fetchEvents() // Actualiza la lista después de agregar un evento
            }
        }
    }
    
    // Función para eliminar un evento por ID
    func deleteEvent(withID id: String) {
    // Encuentra el índice del evento que deseas eliminar
        if let index = events.firstIndex(where: { $0.id == id }) {
            events.remove(at: index)
            // Lógica para eliminar el evento de la base de datos
            eventService.deleteEvent(withID: id) { error in
                if let error = error {
                    print("Error deleting event: \(error.localizedDescription)")
                } else {
                    print("Event deleted successfully")
                }
            }
        } else {
            print("No event found with ID: \(id)")
        }
    }
}
