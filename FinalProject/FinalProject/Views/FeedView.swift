import Foundation
import SwiftUI

struct FeedView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    var loggedUserId: Int64
    @State var posts: [Post]

    init(loggedUserId: Int64) {
        self.loggedUserId = loggedInUserId == -1 ? loggedUserId : loggedInUserId
        loggedInUserId = self.loggedUserId
        self._posts = State(initialValue: [])
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(posts.sorted(by: { $0.postDate > $1.postDate })) { post in
                            PostView(userId: loggedUserId, post: post, inFeedView: true)
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationBarTitle("Feed")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    trailing: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                            .padding()
                            .cornerRadius(10)
                    }
                    .background(
                        NavigationLink(destination: LoginView(isLoggingOut: true)) {
                            EmptyView()
                        }
                        .hidden() // Hide the link view
                    )
                )
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            .onChange(of: selectedTab) { newTab in
                if newTab == 0 {
                    Task {
                        let fetchedPosts = await getPostsRequest()
                        DispatchQueue.main.async {
                            self.posts = fetchedPosts ?? []
                        }
                    }
                }
            }
            .tabItem {
                Label("Feed", systemImage: "list.dash")
            }
            .tag(0)

            NavigationView {
                CreateView(userId: loggedUserId)
                    .navigationBarTitle("Create")
                    .navigationBarHidden(true) // Hide the navigation bar
            }
            .tabItem {
                Label("Create", systemImage: "plus.circle")
            }
            .tag(1)

            NavigationView {
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: ProfileEditView(userId: loggedUserId)) {
                            Text("Edit")
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }

                    ProfileView(userId: loggedUserId)
                        .navigationBarTitle("My Profile")
                        .navigationBarBackButtonHidden(true) // Hide the back button
                }
            }
            .tabItem {
                Label("My Profile", systemImage: "person.crop.circle")
            }
            .tag(2)

            NavigationView {
                FriendshipView(userId: loggedUserId)
                    .navigationBarTitle("Friendships")
            }
            .tabItem {
                Label("Friendships", systemImage: "person.2.fill")
            }
            .tag(3)
        }
        .accentColor(.blue)
        .onAppear {
            selectedTab = 0
            Task {
                let fetchedPosts = await getPostsRequest()
                DispatchQueue.main.async {
                    self.posts = fetchedPosts ?? []
                }
            }
        }
    }
}
