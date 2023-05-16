//
//  User.swift
//  FinalProject
//
//  Created by Student on 4/19/23.
//

import Foundation

struct User: Decodable {
    var userId: Int64
    var name: String
    var password: String
    var email: String
    var profilePicture: String
    var phoneNumber: String
    
    init(userid: Int64, name: String, pass: String, email: String, profilepicture: String, phonenumber: String) {
        self.userId = userid
        self.name = name
        self.password = pass
        self.email = email
        self.profilePicture = profilepicture
        self.phoneNumber = phonenumber
    }
}
