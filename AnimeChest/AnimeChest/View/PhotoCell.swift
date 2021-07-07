//
//  PhotoCell.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/29/21.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: PhotoCell.self)
    
    @IBOutlet weak var animeImageView: UIImageView!
}
