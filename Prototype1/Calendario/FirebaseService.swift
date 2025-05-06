import FirebaseFirestore
import FirebaseStorage
import UIKit
import CoreLocation

class FirebaseService {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    // Método para subir los datos a Firestore
    func sendClothDonation(descriptionClothes: String, contactInfo: String, location: CLLocation?, image: UIImage?, completion: @escaping (Error?) -> Void) {
        var donationData: [String: Any] = [
            "descriptionClothes": descriptionClothes,
            "contactInfo": contactInfo,
            "timestamp": Timestamp()
        ]

        if let location = location {
            donationData["location"] = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }

        if let image = image {
            uploadImage(image) { imageUrl, error in
                if let error = error {
                    completion(error)
                } else if let imageUrl = imageUrl {
                    donationData["imageUrl"] = imageUrl
                    self.db.collection("clothDonations").addDocument(data: donationData) { error in
                        completion(error)
                    }
                }
            }
        } else {
            self.db.collection("clothDonations").addDocument(data: donationData) { error in
                completion(error)
            }
        }
    }

    // Método para subir la imagen a Firebase Storage
    private func uploadImage(_ image: UIImage, completion: @escaping (String?, Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil, NSError(domain: "ImageConversion", code: -1, userInfo: nil))
            return
        }

        let imageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
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
    
    //Método para subir los datos personales a la firebase
    func saveUserData(name: String, lastName: String, phoneNumber: Int, email: String, password: String, completion: @escaping (Error?) -> Void) {
        let personalData: [String: Any] = [
            "name": name,
            "lastName": lastName,
            "phoneNumber": phoneNumber,
            "email": email,
            "password": password
        ]
        db.collection("users").document(email).setData(personalData) { error in
            if let error = error {
                print("Error al guardar los datos: \(error.localizedDescription)")
                completion(error) // Devolver el error en el completion handler
            } else {
                print("Datos guardados exitosamente")
                completion(nil) // Llamar el completion sin error
            }
        }
    }
}
