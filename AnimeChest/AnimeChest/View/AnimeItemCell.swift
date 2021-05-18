//
//  AnimeItemCell.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/18/21.
//

import UIKit

class AnimeItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: AnimeItemCell.self)
    
    @IBOutlet weak var animeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    
}
