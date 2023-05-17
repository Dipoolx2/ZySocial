//
//  FriendshipManager.swift
//  FinalProject
//
//  Created by Student on 5/15/23.
//

import Foundation

func handleFriendRequest(requestId: Int64, accepted: Bool) async -> User? {
    guard let url = URL(string: "https://10.10.137.13:7189/friendship/HandleSimpleFriendRequest/" + String(requestId) + "/" + String(accepted)) else {
        return nil
    }
    var findFriendRequestsRequest = URLRequest(url: url)
    findFriendRequestsRequest.httpMethod = "PUT"
    
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findFriendRequestsRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let user = try decoder.decode(User.self, from: data)
        return user
    } catch {
        return nil
    }
}

func sendFriendRequestToName(userId: Int64, receiverName: String) async -> User? {
    print("https://10.10.137.13:7189/friendship/SendFriendRequestToName/" + String(userId) + "/" + String(receiverName))
    guard let url = URL(string: "https://10.10.137.13:7189/friendship/SendFriendRequestToName/" + String(userId) + "/" + String(receiverName)) else {
        return nil
    }
    var findFriendRequestsRequest = URLRequest(url: url)
    findFriendRequestsRequest.httpMethod = "POST"
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findFriendRequestsRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let friendRequests = try decoder.decode(User.self, from: data)
        return friendRequests
    } catch {
        return nil
    }
}

func removeFriend(userId: Int64, friendId: Int64) async {
    guard let url = URL(string: "https://10.10.137.13:7189/friendship/DeletePotentialFriendRequests/" + String(userId) + "?friendId=" + String(friendId)) else {
        return
    }
    var findFriendRequestsRequest = URLRequest(url: url)
    findFriendRequestsRequest.httpMethod = "DELETE"
    
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findFriendRequestsRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
    } catch {
        print(error)
        return
    }
}

func fetchFriendRequests() async -> [FriendRequest]? {
    guard let url = URL(string: "https://10.10.137.13:7189/friendship/GetSimpleFriendRequests/" ) else {
        return nil
    }
    let findFriendRequestsRequest = URLRequest(url: url)
    
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findFriendRequestsRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let friendRequests = try decoder.decode([FriendRequest].self, from: data)
        return friendRequests
    } catch {
        return nil
    }
}

func fetchIncomingRequests(userId: Int64) async -> [FriendRequest]? {
    guard let url = URL(string: "https://10.10.137.13:7189/friendship/GetIncomingSimpleFriendRequests/"+String(userId) ) else {
        return nil
    }
    let findFriendRequestsRequest = URLRequest(url: url)
    
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findFriendRequestsRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let friendRequests = try decoder.decode([FriendRequest].self, from: data)
        return friendRequests
    } catch {
        return nil
    }
}

func fetchFriendships(userId: Int64) async -> [FriendRequest]? {
    guard let url = URL(string: "https://10.10.137.13:7189/friendship/GetSimpleFriendships/"+String(userId) ) else {
        return nil
    }
    let findFriendRequestsRequest = URLRequest(url: url)
    
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findFriendRequestsRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let friendRequests = try decoder.decode([FriendRequest].self, from: data)
        return friendRequests
    } catch {
        return nil
    }
}

func fetchFriends(userId: Int64) async -> [User]? {
    guard let url = URL(string: "https://10.10.137.13:7189/friendship/GetFriends/"+String(userId) ) else {
        return nil
    }
    let findFriendRequestsRequest = URLRequest(url: url)
    
    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findFriendRequestsRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let friends = try decoder.decode([User].self, from: data)
        print(friends)
        return friends
    } catch {
        return nil
    }
}

