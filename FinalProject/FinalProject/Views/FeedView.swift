import Foundation
import SwiftUI

struct FeedView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    var loggedUserId: Int64
    @Binding var posts: [Post]

    init(loggedUserId: Int64, posts: Binding<[Post]>) {
        self.loggedUserId = loggedInUserId == -1 ? loggedUserId : loggedInUserId
        self._posts = posts
        loggedInUserId = self.loggedUserId
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(posts) { post in
                            PostView(post: post, inFeedView: true)
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationBarTitle("Feed")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Logout")
                            .foregroundColor(.red)
                            .padding()
                            .cornerRadius(10)
                    })
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
            .onAppear {
                selectedTab = 0
            }
            .tabItem {
                Label("Feed", systemImage: "list.dash")
            }
            .tag(0)
            
            NavigationView {
                CreateView()
                    .navigationBarTitle("Create")
                    .navigationBarHidden(true) // Hide the navigation bar
            }
            .tabItem {
                Label("Create", systemImage: "plus.circle")
            }
            .tag(1)
            
            NavigationView {
                
                ProfileView(userId: loggedUserId, posts: getPostsByUserId(userId: loggedUserId))
                    .navigationBarTitle("My Profile")
                    .navigationBarBackButtonHidden(true) // Hide the back button
            
               
            }
            .tabItem {
                Label("My Profile", systemImage: "person.crop.circle")
            }
            .tag(2)
        }
        .accentColor(.blue)
    }
}
