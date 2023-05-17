import Foundation
import SwiftUI

struct CommentsView: View {
    @State private var newCommentText = ""
    var userId: Int64
    var postId: Int64
    @State private var toDisplay: [Comment]

    init(comments: [Comment], userId: Int64, postId: Int64) {
        self.toDisplay = comments
        self.userId = userId
        self.postId = postId
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Comments")
                .font(.title)
                .padding()

            HStack {
                TextField("Add a comment", text: $newCommentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading) // Add left padding to TextField

                Button(action: {
                    addComment()
                }) {
                    Text("Add")
                }
                .padding(.horizontal)
            }
            .padding(.horizontal) // Add horizontal padding to the HStack
            
            List {
                ForEach(Array(toDisplay.enumerated()), id: \.element.commentId) { index, comment in
                    CommentRow(comment: comment, userId: userId) {
                        deleteComment(at: index, commentId: comment.commentId)
                    }
                }
            }
        }
    }

    
    private func addComment() {
        // Perform API request to add comment using `newCommentText`
        // Update `toDisplay` with the newly added comment
        
        // Example code to demonstrate adding a comment locally
        async {
            var newComment: Comment = Comment(commentid: -1, userid: userId, postid: -1, body: newCommentText)
            toDisplay.append(newComment)
            await addCommentRequest(postId: postId, userId: userId, body: newCommentText)
            newCommentText = "" // Clear the text field after adding the comment
        }

    }
    
    private func deleteComment(at index: Int, commentId: Int64) {
        toDisplay.remove(at: index)
        
        // Perform deletion API request here using `commentId`
        async {
            await deleteCommentRequest(commentId: commentId)
        }
    }
}

struct CommentRow: View {
    @State private var user: User?
    var comment: Comment
    var userId: Int64
    var onDelete: () -> Void // Added onDelete closure

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                if let user = user {
                    Text(user.name)
                        .font(.headline)
                } else {
                    Text("User: \(comment.userId)")
                        .font(.headline)
                        .onAppear {
                            fetchUser()
                        }
                }
                Text(comment.body)
                    .font(.body)
            }
            Spacer()
            if comment.userId == userId {
                Button(action: {
                    onDelete() // Call the onDelete closure
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
            if let user = await findUserRequest(userid: comment.userId) {
                DispatchQueue.main.async {
                    self.user = user
                }
            }
        }
    }
}
