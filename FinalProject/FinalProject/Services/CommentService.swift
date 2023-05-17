//
//  CommentService.swift
//  FinalProject
//
//  Created by Student on 5/17/23.
//

import Foundation

func deleteCommentRequest(commentId: Int64) async -> Bool {
    guard let url = URL(string: baseApiURL + "Comment/DeleteComment/"+String(commentId)) else {
        return false
    }
    var findUserRequest = URLRequest(url: url)
    findUserRequest.httpMethod = "DELETE"
    
    do {
        let (_, response) = try await URLSessionManager.shared.data(for: findUserRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            var statusCoddeResponse = response as? HTTPURLResponse
            print("Status code not 200: " + String(statusCoddeResponse!.statusCode))
            return false
        }
        print("deleted successfully")
        return true
    } catch {
        return false
    }
    
}

func addCommentRequest(postId: Int64, userId: Int64, body: String) async -> Bool {
    guard let url = URL(string: baseApiURL + "Comment/PostComment/"+String(postId) + "/" + String(userId) + "/" + body) else {
        return false
    }
    var findUserRequest = URLRequest(url: url)
    findUserRequest.httpMethod = "POST"
    
    do {
        let (_, response) = try await URLSessionManager.shared.data(for: findUserRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            var statusCoddeResponse = response as? HTTPURLResponse
            print("Status code not 200: " + String(statusCoddeResponse!.statusCode))
            return false
        }
        print("deleted successfully")
        return true
    } catch {
        return false
    }
}
