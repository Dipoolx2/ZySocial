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
                        self.friends = await fetchFriends(userId: userId) ?? []
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
                    async {
                        var result = await sendFriendRequestToName(userId: userId, receiverName: searchText)
                        searchText = ""
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top) // Add top padding to the HStack
            
            // List of friend requests
            List {
                Section(header: Text("Friend Requests").font(.headline)) {
                    ForEach(friendRequests, id: \.friendRequestId) { request in
                        HStack {
                            AsyncText(userId: request.userSenderId)
                                .font(.subheadline) // Use a different font style
                                .foregroundColor(.primary) // Reset the foreground color
                            
                            Spacer() // Add spacer here
                            
                            NavigationLink(
                                destination: ProfileView(userId: request.userSenderId)
                            ) {
                                EmptyView() // Use EmptyView to remove the label
                            }
                            .frame(width: 0) // Set width to 0 to make the navigation link invisible
                            
                            Button(action: {
                                // Action to perform when Accept button is tapped
                                print("Accept tapped for \(request.userSenderId)")
                                async {
                                    print("Accepting")
                                    await handleFriendRequest(requestId: request.friendRequestId, accepted: true)
                                    await friends.append(findUserRequest(userid: request.userSenderId)!)
                                    friendRequests.removeAll(where: {$0.friendRequestId == request.friendRequestId })
                                }
                                
                            }) {
                                Text("Accept")
                                    .foregroundColor(.green)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                            }
                            .buttonStyle(PlainButtonStyle()) // Add buttonStyle
                            
                            Button(action: {
                                // Action to perform when Reject button is tapped
                                print("Reject tapped for \(request.userSenderId)")
                                async {
                                    await handleFriendRequest(requestId: request.friendRequestId, accepted: false)
                                    friendRequests.removeAll(where: {$0.friendRequestId == request.friendRequestId })
                                }
                            }) {
                                Text("Reject")
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                            }
                            .buttonStyle(PlainButtonStyle()) // Add buttonStyle
                        }
                    }
                }
            }
            .listStyle(PlainListStyle()) // Apply list style to match the bottom list
            .padding(.top, 8) // Add some padding between the search bar and the list
            .frame(maxHeight: .infinity) // Adjust the height to fill the remaining space
        }
    }
    
    @ViewBuilder
    private var bottomSection: some View {
        VStack {
            Text("Friends")
                .font(.headline)
                .padding(.top, 16)
            
            List(friends, id: \.userId) { friend in
                HStack {
                    Text(friend.name)
                    
                    Spacer()
                    
                    NavigationLink(destination: ProfileView(userId: friend.userId)) {
                        
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Button("Remove") {
                        // Action to perform when the "Remove" button is tapped
                        print("Remove tapped for \(friend.name)")
                        async {
                            await removeFriend(userId: userId, friendId: friend.userId)
                            friends.removeAll(where: { $0.userId == friend.userId })
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .foregroundColor(.red)
                }
            }
            .listStyle(PlainListStyle())
            // Customize the list appearance if desired
            
            // Add additional content or views below the list if needed
        }
        .padding(.horizontal)
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

struct AsyncText: View {
    var userId: Int64
    
    @State private var senderName: String = ""
    
    var body: some View {
        Text(senderName)
            .task {
                if let sender = await findUserRequest(userid: userId) {
                    senderName = sender.name
                }
            }
    }
}
