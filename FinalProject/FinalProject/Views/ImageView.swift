//
//  ImageView.swift
//  FinalProject
//
//  Created by Student on 5/1/23.
//

import Foundation
import SwiftUI

struct ImageView: View {
    @ObservedObject private var imageLoader = ImageLoader()
    private let withURL: String

    init(withURL: String) {
        self.withURL = withURL
        imageLoader.loadImage(fromURL: withURL)
    }

    var body: some View {
        Image(uiImage: imageLoader.image ?? UIImage(systemName: "photo")!)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}
