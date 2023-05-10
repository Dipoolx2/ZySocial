import Foundation
import SwiftUI

struct PostView: View {
    let post: Post
    let user: User?
    let inFeedView: Bool
    @State private var showingComments = false
    @State private var liked = false
    
    init(post: Post, inFeedView: Bool) {
        self.post = post
        self.user = findUser(userid: post.userId)
        self.inFeedView = inFeedView
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let username = user?.Name {
                    if inFeedView {
                        NavigationLink(destination: ProfileView(userId: post.userId, posts: getPostsByUserId(userId: post.userId))) { // Provide an empty array for now
                            Text(username)
                                .font(.headline)}
                    } else {
                        Text(username)
                            .font(.headline)
                    }
                } else {
                    if inFeedView {
                        NavigationLink(destination: ProfileView(userId: post.userId, posts: getPostsByUserId(userId: post.userId))) { // Provide an empty array for now
                            Text("User #\(post.userId)")
                                .font(.headline)}
                    } else {
                        Text("User #\(post.userId)")
                            .font(.headline)
                    }

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
                LikeButtonView(liked: $liked) {
                    // handle like/unlike
                    liked.toggle()
                }
                if (post.showLikes) {
                    Text("\(post.likeCount) likes")
                        .font(.subheadline)
                }
                Spacer()
                if post.allowComments {
                    Button(action: {
                        self.showingComments = true
                    }) {
                        Text("Comments")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $showingComments) {
                        CommentsView(comments: getCommentsInPost(postId: post.id))
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}

struct LikeButtonView: View {
    @Binding var liked: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: liked ? "heart.fill" : "heart")
                .foregroundColor(liked ? .red : .black)
        }
    }
}
