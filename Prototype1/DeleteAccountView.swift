import SwiftUI
import FirebaseAuth

struct DeleteAccountView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var password: String = ""
    @State private var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            // Fondo degradado en tonos blanco y naranja
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.orange]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Header con logo y opción de regresar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Acción para regresar
                    }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.orange)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    Spacer()

                    Image("RED-BAMX") // Logo
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .shadow(radius: 5)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Título principal
                Text("Confirmar eliminación de cuenta")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                // Campo para la contraseña
                SecureField("Introduce tu contraseña", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)

                // Mostrar mensaje de error si existe
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                // Botón para eliminar cuenta
                Button(action: deleteAccount) {
                    Text("Eliminar cuenta")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Botón para regresar al dashboard
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Regresar al Dashboard
                }) {
                    Text("Cancelar")
                        .foregroundColor(.orange)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.top, 20)

                Spacer()
            }
            .padding()
        }
    }

    func deleteAccount() {
        viewModel.deleteAccount(password: password) { success, error in
            if success {
                // Cuenta eliminada con éxito, volver a la pantalla de autenticación
                viewModel.signOut()
                presentationMode.wrappedValue.dismiss() // Cerrar la vista
            } else {
                // Mostrar el mensaje de error
                errorMessage = error
            }
        }
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        // Creación de un viewModel simulado para la vista de previsualización
        let authenticationViewModel = AuthenticationViewModel()

        return DeleteAccountView(viewModel: authenticationViewModel)
    }
}
