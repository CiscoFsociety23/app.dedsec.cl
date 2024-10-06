//
//  UserCreation.swift
//  app.dedsec.cl
//
//  Created by Marco Figueroa on 08-07-24.
//

import SwiftUI

struct UserCreation: View {
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var profile = ""
    @State private var errorMessage = ""
    @State private var isAuthenticated = false
    @State private var token = ""
    
    var body: some View {
        ZStack {
            Color(red: 45/255, green: 50/255, blue: 80/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Crear Usuario")
                    .font(.title)
                    .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                    .padding(.bottom, 40)
                
                // Campo Nombre
                Text("Nombre")
                    .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                TextField("", text: $name)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(red: 66/255, green: 71/255, blue: 105/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(Color(red: 246/255, green: 177/255, blue: 122/255))
                    .multilineTextAlignment(.center)
                
                // Campo Apellido
                Text("Apellido")
                    .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                TextField("", text: $lastName)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(red: 66/255, green: 71/255, blue: 105/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(Color(red: 246/255, green: 177/255, blue: 122/255))
                    .multilineTextAlignment(.center)
                
                // Campo Correo
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
                
                // Campo Contraseña
                Text("Contraseña")
                    .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                SecureField("", text: $password)
                    .padding()
                    .background(Color(red: 66/255, green: 71/255, blue: 105/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(Color(red: 246/255, green: 177/255, blue: 122/255))
                    .multilineTextAlignment(.center)
                
                // Campo Perfil
                Text("Tipo perfil (1: Admin | 2: User)")
                    .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                SecureField("", text: $profile)
                    .padding()
                    .background(Color(red: 66/255, green: 71/255, blue: 105/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(Color(red: 246/255, green: 177/255, blue: 122/255))
                    .multilineTextAlignment(.center)
                
                // Botón de Crear Usuario
                Button(action: {
                    if validateFields() {
                        createUser()
                    } else {
                        errorMessage = "Por favor completa todos los campos."
                    }
                }) {
                    Text("Crear Usuario")
                        .padding()
                        .foregroundColor(Color(red: 45/255, green: 50/255, blue: 80/255))
                        .background(Color(red: 112/255, green: 119/255, blue: 161/255))
                        .cornerRadius(20)
                }
                .padding(.top, 20)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.isPresented = false
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                Text("Retroceder")
                    .foregroundColor(.white)
            }
        })
        .fullScreenCover(isPresented: $isAuthenticated) {
            SuccessView(token: token)
        }
    }
    
    func validateFields() -> Bool {
        return !name.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty && !profile.isEmpty
    }
    
    func createUser() {
        guard let url = URL(string: "https://dedsec.cl/api-mars/users/create") else {
            self.errorMessage = "URL inválida."
            return
        }
        
        let body: [String: Any] = [
            "name": name,
            "lastName": lastName,
            "email": email,
            "passwd": password,
            "profile": Int(profile)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error en la creación del usuario."
                }
                return
            }
            
            // Parse the response if needed
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []), let dictionary = json as? [String: Any] {
                DispatchQueue.main.async {
                    self.token = dictionary["token"] as? String ?? ""
                    self.isAuthenticated = true
                }
            }
        }.resume()
    }
}

struct UserCreation_Previews: PreviewProvider {
    static var previews: some View {
        UserCreation(isPresented: .constant(true))
    }
}
