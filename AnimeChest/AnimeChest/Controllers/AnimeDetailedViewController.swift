//
//  AnimeDetailedViewController.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/23/21.
//

import UIKit

class AnimeDetailedViewController: UIViewController {

    static let identifier = String(describing: AnimeDetailedViewController.self)

    private let animeItem: AnimeItem
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init?(coder: NSCoder, animeItem: AnimeItem) {
        self.animeItem = animeItem
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    



}
