//
//  FirebaseStorageHandler.swift
//  Firebase-Auth
//
//  Created by Cameron Rivera on 3/5/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseStorageHandler {
    private let storageRef = Storage.storage().reference()
    
    public func updatePhoto(userId: String, image: UIImage, completion: @escaping (Result<URL,Error>) -> ()){
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
         let photoReference = storageRef.child("UserProfilePictures/\(userId).jpeg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let _ = photoReference.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                photoReference.downloadURL { (url, error) in
                    if let error  = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
}
