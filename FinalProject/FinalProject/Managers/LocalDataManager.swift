//
//  LocalDataManager.swift
//  FinalProject
//
//  Created by Student on 4/19/23.
//

import Foundation

var loggedInUserId: Int64? = 2

func isLoggedIn() -> Bool {
    return loggedInUserId == nil
}

func getLoggedInName() -> String? {
    if let id = loggedInUserId {
        return findUser(userid: id)?.Name
    } else {
        return nil
    }
}
