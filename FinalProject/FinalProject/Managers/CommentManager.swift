//
//  CommentManager.swift
//  FinalProject
//
//  Created by Student on 5/3/23.
//

import Foundation

var comments: [Comment] = getCommentsFromJson() // Replace w/ API call

func findComment(id: Int64) -> Comment? {
    for comment in comments {
        if comment.CommentId == id {
            return comment
        }
    }
    return nil
}

// TODO: notifications, friends, change profile, api connection

func getCommentsInPost(postId: Int64) -> [Comment] {
    var result: [Comment] = []
    for comment in comments {
        if comment.PostId == postId {
            result.append(comment)
        }
    }
    return result;
}

func getCommentsFromJson() -> [Comment] {
    guard let url = Bundle.main.url(forResource: "Comment", withExtension: "json") else {
        // handle error if the file is not found
        print("Comment.json file could not be found")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        print(data)
        let comments = try JSONDecoder().decode([Comment].self, from: data)
        return comments
    } catch {
        // handle error if the JSON data cannot be parsed
        print("Json data could not be parsed.")
        print(error)
        return []
    }
}
