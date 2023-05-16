//
//  FriendshipView.swift
//  FinalProject
//
//  Created by Student on 5/15/23.
//
import SwiftUI

struct FriendshipView: View {
    var userId: Int64
    @State private var friends: [User] = []
    @State private var friendRequests: [FriendRequest] = []
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            // Top section
            topSection
                .frame(maxHeight: .infinity * 0.3) // Adjust the height here
            
            // Separator
            Rectangle()
                .fill(Color.gray)
                .frame(height: 2)
                .padding(.horizontal)
            
            // Bottom section
            bottomSection
                .frame(maxHeight: .infinity * 0.7) // Adjust the height here
                .onAppear {
                    async {
                        self.friendRequests = await fetchRequestsLocal(userId: userId) ?? []
                    }
                }
        }
        .alignmentGuide(.top) { _ in 0 } // Align to the top
    }

    
    @ViewBuilder
    private var topSection: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 30) // Adjust the height of the search bar
                    .padding(.leading, 8) // Add padding to the left side
                
                Button("Send") {
                    // Action to perform when the Send button is tapped
                    print("Send to " + searchText)
                }
                .padding(.horizontal)
            }
            .padding(.top) // Add top padding to the HStack
            
            Spacer() // Add a spacer to push the content to the top
            
        }
    }

    
    @ViewBuilder
    private var bottomSection: some View {
        VStack {
            Text("Bottom Section")
                // Customize the bottom section view here
                // You can display the list of friend requests or any other content
        }
    }
    
    private func fetchFriendsLocal(userId: Int64) async -> [User]? {
        let fetchedFriendsOpt: [User]? = await fetchFriends(userId: userId)
        if let fetchedFriends = fetchedFriendsOpt {
            return fetchedFriends
        }
        return []
    }
    
    private func fetchRequestsLocal(userId: Int64) async -> [FriendRequest]? {
        let fetchedFriendRequestsOpt: [FriendRequest]? = await fetchIncomingRequests(userId: userId)
        if let fetchedFriendRequests = fetchedFriendRequestsOpt {
            return fetchedFriendRequests
        }
        return []
    }
}
