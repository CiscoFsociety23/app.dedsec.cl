//
//  UserCreation.swift
//  app.dedsec.cl
//
//  Created by Marco Figueroa on 08-07-24.
//

import SwiftUI

struct UserCreation: View {
    var body: some View {
        ZStack {
            Color(red: 45/255, green: 50/255, blue: 80/255)
                .edgesIgnoringSafeArea(.all)
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
        })
    }
}

#Preview {
    UserCreation()
}
