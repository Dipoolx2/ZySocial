//
//  ImageService.swift
//  FinalProject
//
//  Created by Student on 5/16/23.
//

import Foundation
import UIKit

public func uploadImage(image: UIImage) async -> String? {
    do {
        if let imageURL = try await uploadImageToImgur(image: image) {
            print("Image uploaded successfully. URL: \(imageURL)")
            return imageURL
        } else {
            print("Failed to upload image.")
            return nil
        }
    } catch {
        print("Error: \(error)")
        return nil
    }
}

private func uploadImageToImgur(image: UIImage) async throws -> String? {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        return nil
    }
    
    let url = URL(string: "https://api.imgur.com/3/image")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.setValue("Client-ID \()", forHTTPHeaderField: "Authorization") // Replace YOUR_CLIENT_ID with the actual client ID obtained from Imgur.
    request.httpBody = imageData
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
       let imageData = json["data"] as? [String: Any],
       let link = imageData["link"] as? String {
        return link
    } else {
        return nil
    }
}
