//
//  ProfileEditView.swift
//  FinalProject
//
//  Created by Student on 5/16/23.
//

import Foundation
import SwiftUI

struct ProfileEditView: View {
    var userId: Int64
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var selectedProfilePicture: String = ""
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    TextField("Change Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        // Perform actions when the "Change Email" button is tapped
                        // You can add your logic here to handle the email change
                        updateEmail()
                    }) {
                        Text("Change")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.trailing)
                }
                
                HStack {
                    TextField("Change Phone Number", text: $phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        // Perform actions when the "Change Phone Number" button is tapped
                        // You can add your logic here to handle the phone number change
                        updatePhoneNumber()
                    }) {
                        Text("Change")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.trailing)
                }
                
                HStack {
                    Text("Select new profile picture")
                        .padding()
                    
                    Button(action: {
                        // Perform actions when the "Change Profile Picture" button is tapped
                        // You can add your logic here to handle the profile picture change
                        selectProfilePicture()
                    }) {
                        Text("Change")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.trailing)
                }
            }
        }
    }
    
    private func updateEmail() {
        // Implement the logic to update the user's email
        // using the `email` property
    }
    
    private func updatePhoneNumber() {
        // Implement the logic to update the user's phone number
        // using the `phoneNumber` property
    }
    
    private func selectProfilePicture() {
        // Implement the logic to select a new profile picture
        // You can add your own implementation or use a library/component for picking images
    }
}
