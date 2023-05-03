//
//  PostView.swift
//  FinalProject
//
//  Created by Student on 5/1/23.
//

import Foundation
import SwiftUI

struct PostView: View {
    let post: Post
    let user: User?

    init(post: Post) {
        self.post = post
        self.user = findUser(userid: post.userId)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let username = user?.Name {
                    Text(username)
                        .font(.headline)
                } else {
                    Text("User #\(post.userId)")
                        .font(.headline)
                }
                Spacer()
                Text(post.postDate, style: .date)
                    .font(.subheadline)
            }
            Text(post.caption)
                .font(.body)
            if let imageURL = post.image, !imageURL.isEmpty {
                ImageView(withURL: imageURL)
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            HStack {
                Text("\(post.likeCount) likes")
                    .font(.subheadline)
                Spacer()
                if post.allowComments {
                    Text("Comments")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}
