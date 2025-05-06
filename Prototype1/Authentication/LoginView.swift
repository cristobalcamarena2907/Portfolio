import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @ObservedObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Fondo degradado en lugar de la imagen
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
                    Text("Login")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(.white)
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                    
                    Button(action: {
                        viewModel.loginUser(email: email, password: password) { result in
                            switch result {
                            case .success:
                                break // El estado se actualiza automáticamente
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding()
                
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
}

#Preview {
    // Crear un estado simulado para la vista previa
    @StateObject var viewModel = AuthenticationViewModel()
    return LoginView(viewModel: viewModel)
}
