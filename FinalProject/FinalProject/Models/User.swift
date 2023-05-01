//
//  User.swift
//  FinalProject
//
//  Created by Student on 4/19/23.
//

import Foundation

struct User: Decodable {
    var UserId: Int64
    var Name: String
    var Password: String
    var Email: String
    var ProfilePicture: String
    var PhoneNumber: String
    
    init(userid: Int64, name: String, pass: String, email: String, profilepicture: String, phonenumber: String) {
        self.UserId = userid
        self.Name = name
        self.Password = pass
        self.Email = email
        self.ProfilePicture = profilepicture
        self.PhoneNumber = phonenumber
    }
}
