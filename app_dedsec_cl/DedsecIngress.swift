//
//  DedsecIngress.swift
//  app_dedsec_cl
//
//  Created by Marco Figueroa on 08-07-24.
//

import SwiftUI

struct DedsecIngress: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var token: String = ""
    
    var body: some View {
        ZStack {
            Color(red: 45/255, green: 50/255, blue: 80/255)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Ingreso Aplicación")
                    .font(.title)
                    .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                    .padding(.bottom, 40)
                
                // Campo correo
                Text("Correo")
                    .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                TextField("", text: $email)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(red: 66/255, green: 71/255, blue: 105/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(Color(red: 246/255, green: 177/255, blue: 122/255))
                    .multilineTextAlignment(.center)
                
                Text("Contraseña")
                    .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                // Campo contraseña
                SecureField("", text: $password)
                    .padding()
                    .background(Color(red: 66/255, green: 71/255, blue: 105/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(Color(red: 246/255, green: 177/255, blue: 122/255))
                    .multilineTextAlignment(.center)
                
                // Botón ingreso
                Button(action: {
                    if validateEmail(email: email) {
                        sendData(email: email, password: password)
                    } else {
                        errorMessage = "Correo electrónico no válido"
                    }
                }) {
                    Text("Ingresar")
                        .padding()
                        .foregroundColor(Color(red: 45/255, green: 50/255, blue: 80/255))
                        .background(Color(red: 112/255, green: 119/255, blue: 161/255))
                        .cornerRadius(20)
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                }
            }
            .padding(.horizontal, 40)
        }
        .fullScreenCover(isPresented: $isAuthenticated) {
            // Navegar a la vista de éxito o mostrar algo cuando la autenticación es exitosa
            SuccessView(token: token)
        }
    }
    
    // Función para validar el correo electrónico
    func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // Función para enviar datos al endpoint
    func sendData(email: String, password: String) {
        guard let url = URL(string: "https://dedsec.cl/api-mars/users/check") else {
            print("URL no válida")
            return
        }
        
        let body: [String: Any] = ["email": email, "passwd": password]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print("Error al crear el cuerpo de la solicitud: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error en la solicitud: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Datos no válidos"
                }
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let access = jsonResponse["access"] as? Bool, access {
                        if let token = jsonResponse["token"] as? String {
                            DispatchQueue.main.async {
                                self.token = token
                                self.isAuthenticated = true
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Autenticación fallida"
                        }
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al parsear la respuesta: \(error.localizedDescription)"
                }
            }
        }
        
        task.resume()
    }
}

// Vista de éxito
struct SuccessView: View {
    var token: String
    
    var body: some View {
        ZStack {
            Color(red: 45/255, green: 50/255, blue: 80/255)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Autenticación exitosa")
                    .font(.title)
                    .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                    .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    DedsecIngress()
}
