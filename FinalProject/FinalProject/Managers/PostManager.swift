//
//  PostManager.swift
//  FinalProject
//
//  Created by Student on 5/1/23.
//

import Foundation
import SwiftUI

var posts: [Post] = getPostsFromJson() // API CALL

func getPosts() -> Binding<[Post]> {
    return Binding.constant(posts)
}

func getPostsByUserId(userId: Int64) -> Binding<[Post]> {
    var result: [Post] = []
    for post in posts {
        if post.userId == userId {
            result.append(post)
        }
    }
    return Binding.constant(result)
}

func getPostsFromJson() -> [Post] {
    guard let url = Bundle.main.url(forResource: "Post", withExtension: "json") else {
        // handle error if the file is not found
        print("Post.json file could not be found")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        print(data)
        let posts = try JSONDecoder().decode([Post].self, from: data)
        return posts
    } catch {
        // handle error if the JSON data cannot be parsed
        print("Json data could not be parsed.")
        print(error)
        return []
    }
}
