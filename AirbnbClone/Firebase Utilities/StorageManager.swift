//
//  StorageManager.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/14/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

protocol StorageManagerDelegate: AnyObject {
    func didFetchImage(_ storageManager: StorageManager, imageURL: URL)
}

final class StorageManager {  
    weak var delegate: StorageManagerDelegate?
    
    // reference to the firebsase storage app
    private let storageRef: StorageReference = {
        let storage = Storage.storage()
        return storage.reference()
    }()
    
    public func postImage(withData data: Data) {
        guard let user = Auth.auth().currentUser else {
            print("no logged user")
            return
        }
        let imagesRef = storageRef.child(StorageKeys.ImagesKey)
        let newImageRef = imagesRef.child("\(user.uid).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let uploadTask = newImageRef.putData(data, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                print("error uploading data")
                return
            }
            let _ = metadata.size // other properties, content-type
            newImageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("downloadURL error: \(error)")
                } else if let url = url {
                    // can be attached to a document in the a firestore collection as needed
                    print("downloadURL: \(url)")
                    self.delegate?.didFetchImage(self, imageURL: url)
                }
            })
        }
        // observe states on uploadTask
        uploadTask.observe(.failure) { (storageTaskSnapshot) in
            print("failure...")
        }
        uploadTask.observe(.pause) { (storageTaskSnapshot) in
            print("pause...")
        }
        uploadTask.observe(.progress) { (storageTaskSnapshot) in
            print("progress...")
        }
        uploadTask.observe(.resume) { (storageTaskSnapshot) in
            print("resume...")
        }
        uploadTask.observe(.success) { (storageTaskSnapshot) in
            print("success...")
        }
    }
    
    public func uploadNewPostImage(withData data: Data, completionHandler: @escaping(URL?, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        let imageRef = storageRef.child(StorageKeys.postImageKey).child(user.uid)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let uploadtask = imageRef.putData(data, metadata: metaData) { (metaData, error) in
            guard let metadata = metaData else {
                print("error uploading data")
                return
            }
            let _ = metadata.size
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("download error: \(error)")
                    completionHandler(nil, error)
                } else if let url = url {
                    completionHandler(url, nil)
                }
            })
        }
        uploadtask.observe(.failure) { (storageTaskSnapshot) in
            print("failure...")
        }
        uploadtask.observe(.pause) { (storageTaskSnapshot) in
            print("pause...")
        }
        uploadtask.observe(.progress) { (storageTaskSnapshot) in
            print("progress...")
        }
        uploadtask.observe(.resume) { (storageTaskSnapshot) in
            print("resume...")
        }
        uploadtask.observe(.success) { (storageTaskSnapshot) in
            print("success...")
        }
    }
    

}
