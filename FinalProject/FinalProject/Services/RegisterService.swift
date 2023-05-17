//
//  RegisterService.swift
//  FinalProject
//
//  Created by Student on 5/16/23.
//

import Foundation

func registerUser(userName: String, password: String, email: String) async -> Bool {
    guard let url = URL(string: "https://10.10.137.13:7189/user/RegisterNewUser/"+userName+"/"+password+"/"+email) else {
        return false
    }
    var findUserRequest = URLRequest(url: url)
    findUserRequest.httpMethod = "POST"
    
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findUserRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return false
        }
        
        return true
    } catch {
        return false
    }
}
