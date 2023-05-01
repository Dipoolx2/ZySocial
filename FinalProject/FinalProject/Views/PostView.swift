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

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("User \(post.userId)")
                    .font(.headline)
                Spacer()
                Text(post.postDate, style: .date)
                    .font(.subheadline)
            }
            Text(post.caption)
                .font(.body)
            ImageView(withURL: post.image)
                .scaledToFit()
                .frame(maxWidth: .infinity)
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
