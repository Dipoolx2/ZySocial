import Foundation
import SwiftUI

struct FeedView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    @Binding var posts: [Post]

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(posts) { post in
                            PostView(post: post)
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationBarTitle("Feed")
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                    Button(action: {
                        logout()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Logout")
                            .foregroundColor(.red)
                            .padding()
                            .cornerRadius(10)
                    })
                )
            }
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
                    .navigationBarBackButtonHidden(true)
            }
            .tabItem {
                Label("Create", systemImage: "plus.circle")
            }
            .tag(1)
            
            NavigationView {
                ProfileView(userId: loggedInUserId!)
                    .navigationBarTitle("My Profile")
                    .navigationBarBackButtonHidden(true)
            }
            .tabItem {
                Label("My Profile", systemImage: "person.crop.circle")
            }
            .tag(2)
        }
        .accentColor(.blue)
    }
}
