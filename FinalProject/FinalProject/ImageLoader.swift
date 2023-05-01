//
//  ImageLoader.swift
//  FinalProject
//
//  Created by Student on 5/1/23.
//

import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    func loadImage(fromURL urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }

        task.resume()
    }
}
