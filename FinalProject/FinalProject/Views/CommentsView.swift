import Foundation
import SwiftUI

struct CommentsView: View {
    @State private var isShowingCreateCommentAlert = false
    @State private var newCommentText = ""
    
    var toDisplay: [Comment]

    init(comments: [Comment]) {
        self.toDisplay = comments
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Comments")
                .font(.title)
                .padding()
            HStack {
                Spacer()
                Button(action: {
                    self.isShowingCreateCommentAlert = true
                }, label: {
                    Text("Add Comment")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                })
                .padding()
                .alert(isPresented: $isShowingCreateCommentAlert) {
                    Alert(title: Text("New Comment"), message: Text("Enter your comment below:"), primaryButton: .cancel(), secondaryButton: .default(Text("Save"), action: {
                        // save the new comment
                        newCommentText = ""
                    }))
                }
            }
            List(toDisplay, id: \.CommentId) { comment in
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        if let user: User = findUser(userid: comment.UserId) {
                            Text(user.Name)
                                .font(.headline)
                        } else {
                            Text("User: \(comment.UserId)")
                                .font(.headline)
                        }
                        
                        
                        Text(comment.Body)
                            .font(.body)
                    }
                    Spacer()
                    if comment.UserId == loggedInUserId {
                        Button(action: {
                            // delete comment
                        }, label: {
                            Text("Delete")
                                .foregroundColor(.red)
                                .font(.subheadline)
                        })
                    }
                }
            }
        }
    }
}
