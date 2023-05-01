//
//  RegisterView.swift
//  FinalProject
//
//  Created by Student on 4/19/23.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var isShowingLoginView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Register")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                TextField("Username", text: $username)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Email", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    // handle registration logic
                }, label: {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                .padding()
                
                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}
