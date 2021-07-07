//
//  PhotoRepostiory.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/21/21.
//
import Foundation
import FirebaseStorage
import UIKit

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
    
    static func downloadPhoto(from strURL: String, onDataDownloaded: @escaping (UIImage) -> ())  {
        guard let photoURL = URL(string: strURL) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: photoURL) { (data, _, _) in
            if let data = data {
                guard let photo = UIImage(data: data) else { return  }
                onDataDownloaded(photo)
            }
        }
        dataTask.resume()
    }
    
}
