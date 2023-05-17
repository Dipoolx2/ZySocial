//
//  CommentManager.swift
//  FinalProject
//
//  Created by Student on 5/3/23.
//

import Foundation



// TODO: notifications, friends, change profile, api connection

func getCommentsInPost(postId: Int64) async -> [Comment]? {
    guard let url = URL(string: baseApiURL + "comment/GetPostComments/" + String(postId)) else {
        return nil
    }
    var findPostsRequest = URLRequest(url: url)

    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findPostsRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        print(data.description)

        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)

        let comments = try decoder.decode([Comment].self, from: data)
        return comments
    } catch {
        let errorDescription = "\(error.localizedDescription)"
        print("Error: \(errorDescription)")
        return nil
    }
}



func getComments() async -> [Comment]? {
    guard let url = URL(string: baseApiURL + "comment/GetSimpleComments/") else {
        return nil
    }
    var findPostsRequest = URLRequest(url: url)

    do {
        let (data, response) = try await URLSessionManager.shared.data(for: findPostsRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let comments = try decoder.decode([Comment].self, from: data)
        print(comments)
        return comments
    } catch {
        print("error")
        return nil
    }
}
