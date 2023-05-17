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
    
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var selectedProfilePicture: String = ""
    @State private var errorMessage: String = ""
    @State private var successMessage: String = ""
    
    var body: some View {
        VStack {
            Text(successMessage)
                .foregroundColor(.green)
            
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
            
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
                    // Select new profile picture
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Text("Select new profile picture")
                    }
                    .padding(.trailing)
                    
                    // Change profile picture
                    Button(action: {
                        changeProfilePicture()
                        async {
                            if image != nil {
                                let result: String? = await uploadImage(image: image!)
                                if result != nil {
                                    let result2: Bool = await updateUserPicture(userId: userId, profilePicture: result!)
                                    if result2 {
                                        successMessage = "Successfully updated profile picture."
                                        errorMessage = ""
                                        print(result2)
                                    } else {
                                        errorMessage = "Something went wrong."
                                        successMessage = ""
                                    }
                                } else {
                                    errorMessage = "Something went wrong."
                                    successMessage = ""
                                    print("Something went wrong uploading image.")
                                }
                            } else {
                                print("Can't set pfp to an empty image")
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
            }
            
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $image, sourceType: sourceType)
            }
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
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
    
    private func changeProfilePicture() {
        // Implement the logic to change the user's profile picture
        // using the `image` property
    }
    
    private func loadImage() {
        guard let inputImage = image else { return }
        let fixedImage = inputImage.fixedOrientation()
        image = fixedImage
    }
}
