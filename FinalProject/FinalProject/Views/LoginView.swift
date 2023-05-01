//
//  LoginView.swift
//  FinalProject
//
//  Created by Student on 4/17/23.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isShowingRegisterView = false
    @State private var errorMessage = ""
    @State private var isLoggedIn = false // added
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                TextField("Username", text: $username)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if login(username: username, password: password) {
                        print("Logged in as " + getLoggedInName()!)
                        // Navigate to the main app view
                        // Replace MainAppView() with the view you want to navigate to
                        isLoggedIn = true // added
                    } else {
                        errorMessage = "Invalid username or password."
                    }
                }, label: {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                .padding()
                
                NavigationLink(destination: RegisterView(), isActive: $isShowingRegisterView) {
                    Button(action: {
                        isShowingRegisterView = true
                    }, label: {
                        Text("Don't have an account? Register here.")
                            .foregroundColor(.blue)
                            .underline()
                    })
                }
                
                Text(errorMessage)
                    .foregroundColor(.red)
                
                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .background(
                NavigationLink(destination: FeedView(posts: getPosts()), isActive: $isLoggedIn) { // added
                    EmptyView()
                }
            )
        }
    }
}

