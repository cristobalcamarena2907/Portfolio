import SwiftUI

struct RegisterView: View {
    @State private var name = ""
    @State private var lastName = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var passwordStrength = ""
    @State private var phoneErrorMessage = ""
    @State private var passwordErrorMessage = ""
    @ObservedObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Fondo degradado
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.orange]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("RED-BAMX")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.top, 50)
                
                Spacer()
                
                VStack {
                    Text("Registro")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(.white)
                    
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                    
                    TextField("Last Name", text: $lastName)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                    
                    TextField("Phone", text: $phone)
                        .keyboardType(.numberPad)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                        .onChange(of: phone) { newValue in
                            // Limitar solo a dígitos
                            phone = newValue.filter { "0123456789".contains($0) }
                        }
                    
                    // Mensaje de error para el teléfono
                    if !phoneErrorMessage.isEmpty {
                        Text(phoneErrorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 5)
                    }
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                    
                    SecureField("Password", text: $password)
                        .onChange(of: password) { newValue in
                            passwordStrength = viewModel.validatePassword(newValue)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                    
                    SecureField("Confirm password", text: $confirmPassword)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                    
                    Text(passwordStrength)
                        .foregroundColor(passwordStrength == "Fuerte" ? .green : .red)
                        .font(.caption)
                    
                    Button(action: {
                        if password != confirmPassword {
                            errorMessage = "Las contraseñas no coinciden."
                            return
                        }
                        
                        if isPhoneNumberValid(phone) {
                                if passwordStrength == "Fuerte" {
                                    viewModel.registerUser(email: email, password: password) { result in
                                        switch result {
                                        case .success:
                                            viewModel.saveUserData(name: name, lastName: lastName, phoneNumber: Int(phone) ?? 0, email: email, password: password) { error in
                                                if let error = error {
                                                    errorMessage = "Error al guardar los datos: \(error.localizedDescription)"
                                                } else {
                                                    print("Datos guardados exitosamente en Firestore.")
                                                }
                                            }
                                        case .failure(let error):
                                            errorMessage = error.localizedDescription
                                        }
                                    }
                                } else {
                                    errorMessage = "La contraseña no es segura."
                                }
                        } else {
                            phoneErrorMessage = "Número de teléfono inválido."
                        }
                    }) {
                        Text("Registrarse")
                            .foregroundColor(.white)
                            .padding()
                            .background(passwordStrength == "Fuerte" && isPhoneNumberValid(phone) ? Color.blue : Color.green.opacity(0.6)) // Cambié el gris por verde suave
                            .cornerRadius(10)
                    }
                    .disabled(passwordStrength != "Fuerte" || !isPhoneNumberValid(phone))
                    .padding()
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom)
                
                Spacer()
                
                // Botón para volver
                Button(action: {
                    dismiss() // Cierra la vista actual y regresa
                }) {
                    Text("Volver")
                        .font(.title2)
                        .foregroundColor(.orange)
                        .padding()
                        .frame(width: 250, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 20) // Espacio adicional en la parte inferior
                .navigationBarBackButtonHidden(true)
            }
            .padding()
        }
    }
    
    // Función para validar el número de teléfono
    private func isPhoneNumberValid(_ phone: String) -> Bool {
        // Puedes ajustar esta lógica según tus requerimientos
        return phone.count >= 10 // Por ejemplo, requiere al menos 10 dígitos
    }
}

#Preview {
    @StateObject var viewModel = AuthenticationViewModel()
    return RegisterView(viewModel: viewModel)
}
