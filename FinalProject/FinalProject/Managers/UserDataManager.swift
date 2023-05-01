//
//  UserDataManager.swift
//  FinalProject
//
//  Created by Student on 4/19/23.
//

import Foundation

var users: [User] = getUsersFromJson() // API CALL

func findUser(username: String) -> User? {
    print(username)
    for user in users {
        
        if(user.Name == username) {
            return user
        }
    }
    return nil
}

func findUser(userid: Int64) -> User? {
    for user in users {
        if(user.UserId == userid) {
            return user
        }
    }
    return nil
}

func verifyPassword(userid: Int64, password: String) -> Bool {
    if let user = findUser(userid: userid) {
        if(user.Password == password) {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}

func updateUsers() {
    users = getUsersFromJson()
}

func getUsersFromJson() -> [User] {
    guard let url = Bundle.main.url(forResource: "User", withExtension: "json") else {
        // handle error if the file is not found
        print("User.json file could not be found")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        print(data)
        let users = try JSONDecoder().decode([User].self, from: data)
        return users
    } catch {
        // handle error if the JSON data cannot be parsed
        print("Json data could not be parsed.")
        print(error)
        return []
    }
}
