//
//  ImageUploader.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 7/19/23.
//

import FirebaseStorage

struct ImageUploader {
    //responsible for uploading an image to a remote storage service, such as Firebase Storage.
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        
        //defined type
        guard let imageDB = image.jpegData(compressionQuality: 0.75) else { return }
        //defined type
        let fileName = NSUUID().uuidString  // (short for universally unique identifier) is used to generate unique identifiers, converts the unique identifier into a string format.
        
        //defined location
        let reference = Storage.storage().reference(withPath: "/images \(fileName)")
        
        //
        reference.putData(imageDB, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: Failed to upload the image.\(error.localizedDescription)")
                return
            }
            reference.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
        
    }
}

//UploadImage method takes an image, converts it to JPEG data, generates a unique filename, uploads the image data to a remote storage service, retrieves the download URL of the uploaded image, and calls the complition closure with the URL as a string.

