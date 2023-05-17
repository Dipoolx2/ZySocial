import Foundation
import SwiftUI

struct CommentsView: View {
    @State private var newCommentText = ""
    var userId: Int64
    
    var toDisplay: [Comment]

    init(comments: [Comment], userId: Int64) {
        self.toDisplay = comments
        self.userId = userId
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Comments")
                .font(.title)
                .padding()
            List(toDisplay, id: \.CommentId) { comment in
                CommentRow(comment: comment, userId: userId)
            }
        }
    }
}

struct CommentRow: View {
    @State private var user: User?
    var comment: Comment
    var userId: Int64

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                if let user = user {
                    Text(user.name)
                        .font(.headline)
                } else {
                    Text("User: \(comment.UserId)")
                        .font(.headline)
                        .onAppear {
                            fetchUser()
                        }
                }
                Text(comment.Body)
                    .font(.body)
            }
            Spacer()
            if comment.UserId == userId {
                Button(action: {
                    // delete comment
                    async {
                        await deleteCommentRequest(commentId: comment.CommentId)
                    }
                }, label: {
                    Text("Delete")
                        .foregroundColor(.red)
                        .font(.subheadline)
                })
            }
        }
    }
    
    private func fetchUser() {
        async {
            if let user = await findUserRequest(userid: comment.UserId) {
                DispatchQueue.main.async {
                    self.user = user
                }
            }
        }
    }
}
