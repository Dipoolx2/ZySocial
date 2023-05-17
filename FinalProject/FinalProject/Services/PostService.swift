//
//  PostService.swift
//  FinalProject
//
//  Created by Student on 5/16/23.
//

import Foundation

func makePost(userId: Int64, caption: String, image: String?, likes: Bool, comments: Bool) async -> Bool {
    print("Making post")
    
    let pictureTag: String? = image != nil ? String(image!.dropFirst(20)) : nil
    let likesString = String(likes)
    let commentsString = String(comments)

    guard let urlString = "https://10.10.137.13:7189/post/NewPost/\(userId)/\(caption)/\(pictureTag ?? "null")/\(likesString)/\(commentsString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: urlString) else {
        return false
    }

    var findUserRequest = URLRequest(url: url)
    findUserRequest.httpMethod = "POST"

    do {
        let (_, response) = try await URLSessionManager.shared.data(for: findUserRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return false
        }

        return true
    } catch {
        return false
    }
}
