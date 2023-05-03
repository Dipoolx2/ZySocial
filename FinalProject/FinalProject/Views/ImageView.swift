//
//  ImageView.swift
//  FinalProject
//
//  Created by Student on 5/1/23.
//

import Foundation
import SwiftUI

struct ImageView: View {
    @ObservedObject private var imageLoader2 = ImageLoader2()
    private let withURL: String

    init(withURL: String) {
        self.withURL = withURL
        imageLoader2.loadImage(fromURL: withURL)
    }

    var body: some View {
        Image(uiImage: imageLoader2.image ?? UIImage(systemName: "photo")!)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

class ImageLoader2: ObservableObject {
    @Published var image: UIImage?

    private var imageDownloadTask: URLSessionDataTask?

    func loadImage(fromURL urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        imageDownloadTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }

        imageDownloadTask?.resume()
    }
}
