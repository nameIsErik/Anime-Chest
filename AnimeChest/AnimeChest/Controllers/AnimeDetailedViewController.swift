//
//  AnimeDetailedViewController.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/23/21.
//

import UIKit

class AnimeDetailedViewController: UIViewController {

    static let identifier = String(describing: AnimeDetailedViewController.self)

    @IBOutlet weak var animeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var animeTitleLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var animeEpisodesLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var watchVideoButton: UIButton!
    
    
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
        setupView()

        
    }
    
    private func setupView() {
        animeTitleLabel.text = animeItem.title
        animeEpisodesLabel.text = String(animeItem.episodes)
        descriptionTextView.text = animeItem.animeDescription
    }


}
