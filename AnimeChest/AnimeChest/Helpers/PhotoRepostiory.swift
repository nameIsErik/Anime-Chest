//
//  PhotoRepostiory.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/21/21.
//

import FirebaseStorage

class PhotoRepository {
    private static let storage = Storage.storage()
    
    static func uploadPhoto(data: Data, onLinkLoaded: @escaping (String) -> ()) {
        let storageRef = storage.reference()
        
        let photoId = UUID().uuidString
        let photosRef = storageRef
            .child(Constants.StorageReferences.imagesFolder)
            .child(photoId)
        
        photosRef.putData(data, metadata: nil) { metadata, error in
            guard let _ = metadata else {
                return
            }
            
            photosRef.downloadURL { (url, error) in
                if let link = url {
                    onLinkLoaded(link.absoluteString)
                } else {
                    return
                }
            }
    
        }
    }
}
