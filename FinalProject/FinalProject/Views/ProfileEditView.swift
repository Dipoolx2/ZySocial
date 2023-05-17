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
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Button(action: {
                // Handle Edit Email action
            }) {
                Text("Edit Email")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Button(action: {
                // Handle Edit Phone Number action
            }) {
                Text("Edit Phone Number")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Button(action: {
                // Handle Edit Profile Picture action
            }) {
                Text("Edit Profile Picture")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.vertical)
        .navigationBarTitle("Edit Profile")
        .navigationBarItems(trailing: Button(action: {
            // Handle Submit action
        }) {
            Text("Submit")
                .foregroundColor(.blue)
                .padding()
        })
    }
}
