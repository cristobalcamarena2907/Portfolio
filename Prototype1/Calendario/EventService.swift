import FirebaseFirestore
import FirebaseStorage
import UIKit
import CoreLocation

class EventService {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let collectionName = "events"
    
    // Guardar evento en Firebase
    func saveEvent(id: String, title: String, date: Date, location: CLLocationCoordinate2D, description: String, image: UIImage?, link: String, address: String, completion: @escaping (Error?) -> Void) {
        var eventData: [String: Any] = [
            "id": id,
            "title": title,
            "date": Timestamp(date: date),
            "location": GeoPoint(latitude: location.latitude, longitude: location.longitude),
            "description": description,
            "link": link,
            "address": address
        ]
        
        if let image = image {
            uploadEventImage(image) { imageUrl, error in
                if let error = error {
                    completion(error)
                } else if let imageUrl = imageUrl {
                    eventData["imageUrl"] = imageUrl
                    self.db.collection("events").addDocument(data: eventData, completion: completion)
                }
            }
        } else {
            self.db.collection("events").addDocument(data: eventData, completion: completion)
        }
    }
    
    func deleteEvent(withID id: String, completion: @escaping (Error?) -> Void) {
            db.collection(collectionName).document(id).delete { error in
                if let error = error {
                    print("Error deleting document: \(error.localizedDescription)")
                    completion(error)
                } else {
                    print("Document successfully deleted!")
                    completion(nil)
                }
            }
        }
    
    // Recuperar eventos de Firebase
    func getEvents(completion: @escaping ([Event], Error?) -> Void) {
        db.collection("events").getDocuments { snapshot, error in
            if let error = error {
                completion([], error)
                return
            }
            
            let events = snapshot?.documents.compactMap { document -> Event? in
                let data = document.data()
                guard
                    let id = data["id"] as? String,
                    let title = data["title"] as? String,
                    let timestamp = data["date"] as? Timestamp,
                    let geoPoint = data["location"] as? GeoPoint,
                    let description = data["description"] as? String,
                    let link = data["link"] as? String,
                    let address = data["address"] as? String
                else {
                    return nil
                }
                
                let date = timestamp.dateValue()
                let location = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                let imageUrl = data["imageUrl"] as? String
                
                return Event(id: id, title: title, date: date, location: location, description: description, imageUrl: imageUrl, link: link, address: address)
            } ?? []
            
            completion(events, nil)
        }
    }
    
    // Subir imagen de evento a Firebase Storage
    private func uploadEventImage(_ image: UIImage, completion: @escaping (String?, Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil, NSError(domain: "ImageConversion", code: -1, userInfo: nil))
            return
        }
        
        let imageRef = storage.reference().child("event_images/\(UUID().uuidString).jpg")
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(nil, error)
            } else {
                imageRef.downloadURL { url, error in
                    if let url = url {
                        completion(url.absoluteString, nil)
                    } else {
                        completion(nil, error)
                    }
                }
            }
        }
    }
}
