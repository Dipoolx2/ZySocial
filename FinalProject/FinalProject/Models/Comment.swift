//
//  Comment.swift
//  FinalProject
//
//  Created by Student on 5/3/23.
//

import Foundation

struct Comment: Decodable {
    var CommentId: Int64
    var UserId: Int64
    var PostId: Int64
    var Body: String
    
    init(commentid: Int64, userid: Int64, postid: Int64, body: String) {
        self.CommentId = commentid
        self.UserId = userid
        self.PostId = postid
        self.Body = body
    }
}
