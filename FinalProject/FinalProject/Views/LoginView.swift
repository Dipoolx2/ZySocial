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
    @State private var logUserId: Int64 = -1
    
    init(isLoggingOut: Bool) {
        logout()
    }
    
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
                    async {
                        let loggedIn = await login(username: username, password: password)
                        
                        if loggedIn {
                            isLoggedIn = true
                            logUserId = loggedInUserId
                        } else {
                            isLoggedIn = false
                            errorMessage = "Invalid username or password"
                        }
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(isLoggedIn)
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
                NavigationLink(destination: FeedView(loggedUserId: logUserId, posts: getPosts()), isActive: $isLoggedIn) { // added
                    EmptyView()
                }
            )
        }
    }
}

