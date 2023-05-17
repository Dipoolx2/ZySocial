//
//  PostManager.swift
//  FinalProject
//
//  Created by Student on 5/1/23.
//

import Foundation
import SwiftUI

func getPostsRequest() async -> [Post]? {
    print("getting posts")
    guard let url = URL(string: baseApiURL + "post/GetSimplePosts/") else {
        
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
        
        let posts = try decoder.decode([Post].self, from: data)
        print(posts)
        return posts
    } catch {
        print("error")
        return nil
    }
}

func getUserPosts(userId: Int64) async -> [Post]? {
    guard let url = URL(string: baseApiURL + "post/GetUserPosts/" + String(userId)) else {
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
        
        let posts = try decoder.decode([Post].self, from: data)
        return posts
    } catch {
        return nil
    }
}
