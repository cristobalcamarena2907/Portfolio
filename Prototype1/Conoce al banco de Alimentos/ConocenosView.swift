import SwiftUI

struct ConocenosView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo degradado similar al resto de las pantallas
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.orange]),
                               startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header con logo y título
                        HStack {
                            Button(action: {
                                dismiss() // Acción para regresar al presionar el logo
                            }) {
                                Image("RED-BAMX")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .shadow(radius: 5)
                            }

                            Spacer()

                            Text("Conócenos")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .shadow(radius: 5)
                        
                        // Imagen destacada con estilo moderno
                        Image("zero_hunger")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                        
                        // Sección de Donar con descripción mejorada
                        VStack(spacing: 15) {
                            Text(" ")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .bold()
                            
                            Text("El Banco de Alimentos de México (BAMX) es una organización sin fines de lucro que trabaja para combatir el hambre y mejorar la nutrición de las personas en situación vulnerable. A través de la recuperación de alimentos que de otra manera serían desperdiciados, BAMX distribuye estos productos a quienes más lo necesitan. Gracias a una red de voluntarios y alianzas con empresas y donadores, BAMX es capaz de impactar a miles de familias cada día, fomentando una cultura de solidaridad y responsabilidad social.")
                                .font(.body)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(radius: 2)
                                .padding(.horizontal)
                        }
                        
                        // Botón para abrir el enlace de donaciones
                        Button(action: {
                            openURL(URL(string: "https://bamx.org.mx/formas-de-donar/")!)
                        }) {
                            HStack {
                                Image(systemName: "link")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                Text("Donar en la página")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // Botón para la donación de ropa que lleva a ResiduoView
                        NavigationLink(destination: ResiduoView().navigationBarBackButtonHidden(true)) {
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                Text("Donar ropa")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // Botón para regresar al dashboard
                        Button(action: {
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "arrow.backward")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                Text("Regresar al Dashboard")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                    .padding(.top, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ConocenosView()
}
