//
//  FinalProjectApp.swift
//  FinalProject
//
//  Created by Student on 4/17/23.
//

import SwiftUI

@main
struct FinalProjectApp: App {
    var body: some Scene {
        WindowGroup {
            FeedView(posts: getPosts())
        }
    }
}
