import FirebaseFirestore
import FirebaseStorage
import Foundation
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user: User? // Aquí almacenamos al usuario autenticado
    @Published var errorMessage: String?

    init() {
        self.user = Auth.auth().currentUser
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.user = result?.user // Asignamos al usuario autenticado
                self.isLoggedIn = true
                completion(.success(()))
            }
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.user = result?.user // Asignamos al usuario autenticado
                self.isLoggedIn = true
                completion(.success(()))
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.user = nil // Reiniciamos el usuario autenticado
        } catch let error as NSError {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    // Función para verificar si el correo del usuario autenticado es el del administrador
    func isAdmin() -> Bool {
        return user?.email == "bagudevsac@gmail.com"
    }

    func saveUserData(name: String, lastName: String, phoneNumber: Int, email: String, password: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let personalData: [String: Any] = [
            "name": name,
            "lastName": lastName,
            "phoneNumber": phoneNumber,
            "email": email
        ]
            
        db.collection("users").document(email).setData(personalData) { error in
            completion(error)
        }
    }
    
    func validatePassword(_ password: String) -> String {
        if password.count < 8 {
            return "La contraseña debe tener al menos 8 caracteres."
        }
        if !password.contains(where: { $0.isUppercase }) {
            return "La contraseña debe tener al menos una letra mayúscula."
        }
        if !password.contains(where: { $0.isLowercase }) {
            return "La contraseña debe tener al menos una letra minúscula."
        }
        if !password.contains(where: { $0.isNumber }) {
            return "La contraseña debe tener al menos un número."
        }
        if !password.contains(where: { "!@#$%^&*()_+-=[]{}|;':,.<>?/".contains($0) }) {
            return "La contraseña debe tener al menos un carácter especial."
        }
        return "Fuerte"
    }
    
    func deleteAccount(password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            completion(false, "No se pudo obtener la información del usuario.")
            return
        }

        // Credenciales del usuario
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        // Reautenticación del usuario
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                completion(false, "Contraseña incorrecta: \(error.localizedDescription)")
                return
            }

            // Si la reautenticación es exitosa, eliminar la cuenta
            user.delete { error in
                if let error = error {
                    completion(false, "Error al eliminar la cuenta: \(error.localizedDescription)")
                } else {
                    completion(true, nil) // Eliminar cuenta exitoso
                }
            }
        }
    }
}
