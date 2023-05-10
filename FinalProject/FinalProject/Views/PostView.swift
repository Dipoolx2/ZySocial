import Foundation
import SwiftUI

struct PostView: View {
    let post: Post
    let user: User?
    @State private var showingComments = false
    @State private var liked = false
    
    init(post: Post) {
        self.post = post
        self.user = findUser(userid: post.userId)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let username = user?.Name {
                    NavigationLink(destination: ProfileView(userId: post.userId)) {
                        Text(username)
                            .font(.headline)
                    }
                } else {
                    NavigationLink(destination: ProfileView(userId: post.userId)) {
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
