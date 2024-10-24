import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseStorage
import UIKit
import CoreLocation
import Combine

struct ResiduoView: View {
    @StateObject private var viewModel = DonateClothesViewModel()
    @Environment(\.dismiss) var dismiss
    
    var isDescriptionValid: Bool {
        !viewModel.descriptionClothes.isEmpty && viewModel.descriptionClothes.count >= 5
    }
    
    var body: some View {
        ZStack {
            // Fondo degradado similar al estilo proporcionado
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.orange]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Encabezado con logo y título en fondo blanco
                HStack {
                    Button(action: {
                        dismiss() // Acción del logo para regresar
                    }) {
                        Image("RED-BAMX") // Logo
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .shadow(radius: 5)
                    }

                    Spacer()

                    Text("Reportar Ropa")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white) // Fondo blanco
                .shadow(radius: 5)
                
                VStack {
                    Text("¡Tu generosidad puede vestir el")
                        .font(.title2) // Cambié a .title2 para un mejor ajuste
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center) // Centra el texto
                        .frame(maxWidth: .infinity) // Ocupa todo el ancho disponible
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.bottom, -2)
                    
                    Text("futuro de alguien más!")
                        .font(.title2) // Cambié a .title2 para un mejor ajuste
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center) // Centra el texto
                        .frame(maxWidth: .infinity) // Ocupa todo el ancho disponible
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.top, -1)
                }
                .background(Color.white.opacity(0.7))
                .cornerRadius(10)
                .padding(.horizontal)
                
                VStack {
                    Text("¿Tienes ropa que te gustaría donar? ¡Cuéntanos sobre los artículos! Nos encargaremos de registrar tu información y te contactaremos para coordinar la recolección. ¡Gracias por contribuir!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .frame(minHeight: 150) // Hacer el cuadro más grande
                }
                                
                // Campo de descripción
                TextField("Descripción de la ropa...", text: $viewModel.descriptionClothes)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .onReceive(Just(viewModel.descriptionClothes)) { newValue in
                        let filtered = newValue.filter { $0.isLetter || $0.isWhitespace }
                        if filtered != newValue {
                            viewModel.descriptionClothes = filtered
                        }
                    }
                
                // Validación de descripción
                if !isDescriptionValid {
                    Text("La descripción debe tener al menos 5 caracteres.")
                        .font(.footnote)
                        .foregroundColor(.black)
                    
                }
                
                // Estado de la ubicación
                /*Text(viewModel.locationStatus)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()*/
                
                // Botón para enviar ubicación
                /*Button(action: {
                    viewModel.requestLocation()
                }) {
                    Text("Enviar Ubicación")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)*/
                
                // Mostrar imagen seleccionada
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                }
                
                
                // Botón para tomar foto
                Button(action: {
                    viewModel.showImagePicker = true
                }) {
                    Text("Tomar Foto")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .sheet(isPresented: $viewModel.showImagePicker) {
                    ImagePicker(image: $viewModel.image, sourceType: .camera)
                }
                
                Text("Propociona un teléfono o correo de contacto.")
                    .multilineTextAlignment(.center)
                    .cornerRadius(15)
                    .padding(.horizontal)
                
                
                TextField("Teléfono/Correo", text: $viewModel.contactInfo)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                
                // Botón para enviar donación
                Button(action: {
                    viewModel.sendDonation()
                }) {
                    Text("Enviar Donación")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                // Texto explicativo con recuadro más grande
                /*VStack {
                    Text("¿Tienes ropa que te gustaría donar? ¡Cuéntanos sobre los artículos! Nos encargaremos de registrar tu información y te contactaremos para coordinar la recolección. ¡Gracias por contribuir!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .frame(minHeight: 150) // Hacer el cuadro más grande
                }*/
                
                Spacer()
                
                // Botón para regresar al dashboard
                Button(action: {
                    dismiss()
                }) {
                    Text("Regresar al Dashboard")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.gray]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ResiduoView()
}
