//
//  Comment.swift
//  FinalProject
//
//  Created by Student on 5/3/23.
//

import Foundation

struct Comment: Decodable {
    var commentId: Int64
    var userId: Int64
    var postId: Int64
    var body: String
    
    init(commentid: Int64, userid: Int64, postid: Int64, body: String) {
        self.commentId = commentid
        self.userId = userid
        self.postId = postid
        self.body = body
    }
}
