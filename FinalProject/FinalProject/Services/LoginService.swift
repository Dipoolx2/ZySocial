//
//  LoginService.swift
//  FinalProject
//
//  Created by Student on 4/19/23.
//

import Foundation
import UIKit

func login(username: String, password: String) async -> Bool {
    let result = await loginUserRequest(username: username, password: password)
    
    if result != -1 {
        print("Password is correct")
        loggedInUserId = result
        print(loggedInUserId)
        return true
    } else {
        return false
    }
}

func sendWrongPasswordAlert() {
    print("Wrong password")
}

func sendCouldntFindUserAlert() {
    print("Couldn't find that user")
}

func loginUserRequest(username: String, password: String) async -> Int64 {
    guard let url = URL(string: baseApiURL + "user/LoginSimpleUser?username="+String(username)+"&password="+password) else {
        return -1
    }
    let findUserRequest = URLRequest(url: url)
    
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findUserRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return -1
        }
        
        let decoder = JSONDecoder()
        let userId = try decoder.decode(UserId.self, from: data)
        return userId.userId
    } catch {
        return -1
    }
}

struct UserId: Decodable {
    var userId: Int64
}

