//
//  LocalDataManager.swift
//  FinalProject
//
//  Created by Student on 4/19/23.
//

import Foundation

var loggedInUserId: Int64 = 2

func isLoggedIn() -> Bool {
    return loggedInUserId != -1
}

func getLoggedInName() -> String? {
    if loggedInUserId != -1 {
        async {
            let user = await findUserRequest(userid: loggedInUserId)
            return user?.name
        }
    }
    return nil
}
