import Foundation
import SwiftUI

struct PostView: View {
    var userId: Int64
    var post: Post
    @State public var commentsInPost: [Comment] = []
    @State public var user: User?
    let inFeedView: Bool
    @State public var showingComments = false
    @State public var liked = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let username = user?.name {
                    if inFeedView {
                        NavigationLink(destination: ProfileView(userId: post.userId)) { // Provide an empty array for now
                            Text(username)
                                .font(.headline)
                        }
                    } else {
                        Text(username)
                            .font(.headline)
                    }
                } else {
                    if inFeedView {
                        NavigationLink(destination: ProfileView(userId: post.userId)) { // Provide an empty array for now
                            Text("User #\(post.userId)")
                                .font(.headline)
                        }
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
                        CommentsView(comments: commentsInPost, userId: userId, postId: post.id)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
        .onAppear {
            fetchUser()
            fetchCommentsInPost()
        }
    }
    
    func fetchUser() {
        async {
            let fetchedUser = await findUserRequest(userid: post.userId)
            DispatchQueue.main.async {
                self.user = fetchedUser
            }
        }
    }
    func fetchCommentsInPost() {
        async {
            let fetchedComments = await getCommentsInPost(postId: post.id)
            DispatchQueue.main.async {
                self.commentsInPost = fetchedComments ?? []
            }
        }
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
