//
//  LoginService.swift
//  FinalProject
//
//  Created by Student on 4/19/23.
//

import Foundation
import UIKit

func login(username: String, password: String) -> Bool {
    print("Logging in")
    var loginUser: User? = findUser(username: username)
    if let user = loginUser {
        print("User exists")
        if verifyPassword(userid: user.UserId, password: password) {
            print("Password is correct")
            loggedInUserId = user.UserId
            return true
        } else {
            sendWrongPasswordAlert()
            return false
        }
    } else {
        sendCouldntFindUserAlert()
        return false
    }
    // Perform authentication logic here
    // Return true if the authentication is successful, false otherwise
}

func sendWrongPasswordAlert() {
    print("Wrong password")
}

func sendCouldntFindUserAlert() {
    print("Couldn't find that user")
}
