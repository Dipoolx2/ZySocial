//
//  CreateView.swift
//  FinalProject
//
//  Created by Student on 4/17/23.
//

import Foundation
import SwiftUI
import UIKit

struct CreateView: View {
    
    var userId: Int64
    
    @State private var image: UIImage?
    @State private var caption: String = ""
    @State private var allowComments: Bool = true
    @State private var showLikes: Bool = true
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var successMessage: String = ""
    @State private var failureMessage: String = ""
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
            
            Button(action: {
                showingImagePicker = true
            }) {
                Text("Choose Image")
            }
            
            TextField("Add a caption", text: $caption)
                .padding()
                .frame(height: 100)
            
            HStack {
                Text("Allow Commenting")
                Spacer()
                Toggle("", isOn: $allowComments)
            }
            .padding()
            
            HStack {
                Text("Show Likes")
                Spacer()
                Toggle("", isOn: $showLikes)
            }
            .padding()
            
            Text(failureMessage).foregroundColor(.red)
            Text(successMessage).foregroundColor(.green)
            
            Spacer()
            
            Button(action: {
                async {
                    var imageLink: String? = nil
                    if image != nil {
                        let result = await uploadImage(image: image!)
                        if result != nil {
                            imageLink = result
                        }
                    }
                    
                    let result = await makePost(userId:userId, caption:caption, image:imageLink, likes: showLikes, comments: allowComments)
                    if result {
                        successMessage = "Successfully made the post."
                        failureMessage = ""
                    } else {
                        successMessage = ""
                        failureMessage = "Something went wrong."
                    }
                    resetFields()
                }
            }, label: {
                Text("Post")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            })
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $image, sourceType: sourceType)
        }
        .navigationBarItems(trailing: Button(action: {
            // Post
            resetFields()
            
        }, label: {
            Text("Post")
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        }))
    }

    
    func loadImage() {
        guard let inputImage = image else { return }
        let fixedImage = inputImage.fixedOrientation()
        image = fixedImage
    }
    
    func resetFields() {
        image = nil
        caption = ""
        allowComments = true
        showLikes = true
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

extension UIImage {
    func fixedOrientation() -> UIImage {
        if imageOrientation == .up { return self }
        
        var transform: CGAffineTransform = .identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi / 2.0)
        default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        guard let cgImage = cgImage, let colorSpace = cgImage.colorSpace else { return self }
        
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
                                space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue)!
        
        context.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        guard let finalImage = context.makeImage() else { return self }
        return UIImage(cgImage: finalImage)
    }
}
