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
    @State private var errorMessage: String = ""
    @State private var successMessage: String = ""
    var body: some View {
        VStack {
            Text(successMessage).foregroundColor(.green)
            Text(errorMessage).foregroundColor(.red).padding()
            VStack {
                HStack {
                    TextField("Change Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        // Perform actions when the "Change Email" button is tapped
                        // You can add your logic here to handle the email change
                        async {
                            var response = await updateUserEmail(userId:userId, email:email)
                            if response {
                                successMessage = "Email changed successfully."
                                errorMessage = ""
                            } else {
                                errorMessage = "Invalid email. Try picking another."
                                successMessage = ""
                            }
                        }
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
                        async {
                            var response = await updateUserPhoneNumber(userId:userId, phoneNumber:phoneNumber)
                            if response {
                                successMessage = "Phone number changed successfully."
                                errorMessage = ""
                            } else {
                                errorMessage = "Invalid phone number. Try picking another."
                                successMessage = ""
                            }
                        }
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
    
    private func updatePhoneNumber() {
        // Implement the logic to update the user's phone number
        // using the `phoneNumber` property
    }
    
    private func selectProfilePicture() {
        // Implement the logic to select a new profile picture
        // You can add your own implementation or use a library/component for picking images
    }
}
