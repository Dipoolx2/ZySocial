//
//  UserDataManager.swift
//  FinalProject
//
//  Created by Student on 4/19/23.
//

import Foundation

func getSharedSession() -> URLSession {
    return URLSessionManager.shared
}

func findUserRequest(userid: Int64) async -> User? {
    guard let url = URL(string: baseApiURL + "user/GetSimpleUser/"+String(userid)) else {
        return nil
    }
    let findUserRequest = URLRequest(url: url)
    
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findUserRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: data)
        return user
    } catch {
        return nil
    }
}

func updateUserEmail(userId: Int64, email: String) async -> Bool {
    guard let url = URL(string: baseApiURL + "user/UpdateUserEmail/" + String(userId) + "/" + email) else {
        return false
    }
    var findFriendRequestsRequest = URLRequest(url: url)
    findFriendRequestsRequest.httpMethod = "PUT"
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findFriendRequestsRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return false
        }
        return true
    } catch {
        return false
    }
}

func updateUserPhoneNumber(userId: Int64, phoneNumber: String) async -> Bool {
    guard let url = URL(string: baseApiURL + "user/UpdateUserPhoneNumber/" + String(userId) + "/" + phoneNumber) else {
        return false
    }
    var findFriendRequestsRequest = URLRequest(url: url)
    findFriendRequestsRequest.httpMethod = "PUT"
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findFriendRequestsRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return false
        }
        return true
    } catch {
        return false
    }
}

func updateUserPicture(userId: Int64, profilePicture: String) async -> Bool {
    let pictureTag:String = String(profilePicture.dropFirst(20))
    print("picture tag: " + pictureTag)
    guard let url = URL(string: baseApiURL + "user/UpdateUserPicture/" + String(userId) + "/" + pictureTag) else {
        return false
    }
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return false
        }
        
        return true
    } catch {
        return false
    }
}

class InsecureSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
}

class URLSessionManager {
    static let shared: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache = nil
        sessionConfig.timeoutIntervalForResource = 30

        let session = URLSession(configuration: sessionConfig, delegate: InsecureSessionDelegate(), delegateQueue: nil)
        return session
    }()
}
