//
//  ContentView.swift
//  app_dedsec_cl
//
//  Created by Marco Figueroa on 07-07-24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 45/255, green: 50/255, blue: 80/255)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Dedsec Corp")
                        .font(.title)
                        .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                    Text("Mobile App")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 112/255, green: 119/255, blue: 161/255))
                    NavigationLink(destination: DedsecIngress()){
                        Text("Ingresar")
                            .padding()
                            .foregroundColor(Color(red: 45/255, green: 50/255, blue: 80/255))
                            .background(Color(red: 112/255, green: 119/255, blue: 161/255))
                            .cornerRadius(20)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
