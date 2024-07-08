//
//  ContentView.swift
//  app_dedsec_cl
//
//  Created by Marco Figueroa on 07-07-24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.176, green: 0.196, blue: 0.314)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Dedsec Corp")
                    .font(.title)
                    .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                Text("Mobile App")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                Button(action: {
                    print("Botón presionado")
                }) {
                    Text("Ingresar")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(red: 112/255, green: 119/255, blue: 161/255))
                        .foregroundColor(Color(red: 45/255, green: 50/255, blue: 80/255))
                        .cornerRadius(20)
                }
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    ContentView()
}

