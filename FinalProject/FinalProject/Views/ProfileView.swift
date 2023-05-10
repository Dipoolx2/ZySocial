//
//  ProfileView.swift
//  FinalProject
//
//  Created by Student on 4/17/23.
//
import Foundation
import SwiftUI
import Combine

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    let userId: Int64
    
    init(userId: Int64) {
        self.userId = userId
        _viewModel = StateObject(wrappedValue: ProfileViewModel(userId: userId))
    }
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            } else {
                ProgressView()
            }
            Text(viewModel.username)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 16)
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("Email:")
                    Text("Phone:")
                }
                VStack(alignment: .trailing) {
                    Text(viewModel.email)
                    Text(viewModel.phone)
                }
            }
            .padding(.top, 32)
            .padding(.bottom, 32) // add padding to the bottom of the VStack
            Divider() // add a horizontal separator
            List {
                ForEach(0..<viewModel.posts.count) { index in
                    Text(viewModel.posts[index])
                }
            }
        }
        .padding()
        .onAppear {
            let user = findUser(userid: userId)!
            viewModel.username = findUser(userid: user.UserId)!.Name
            viewModel.email = user.Email
            viewModel.phone = user.PhoneNumber
            viewModel.fetchProfile(urlString: user.ProfilePicture)
        }
        .navigationBarTitle("")
    }
}
    
class ProfileViewModel: ObservableObject {
    private let userId: Int64
    
    @Published var image: UIImage?
    @Published var username: String = "John Doe"
    @Published var email: String = "johndoe@example.com"
    @Published var phone: String = "+1-123-456-7890"
    @Published var posts: [String] = ["Post 1", "Post 2", "Post 3"] // mock data for posts
    
    init(userId: Int64) {
        self.userId = userId
    }

    private var cancellable: AnyCancellable?
    
    func fetchProfile(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

