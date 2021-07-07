//
//  AnimeDetailedViewController.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/23/21.
//

import UIKit
import AVKit

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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(onEditTapped))
        
        animeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPhotoCollection))
        animeImageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func showPhotoCollection() {
        
        if let plantDetailController = storyboard?.instantiateViewController(identifier: PhotoCollectionViewController.identifier, creator: { coder in
            return PhotoCollectionViewController(coder: coder, animeItem: self.animeItem, isEditMode: false)
        }) {
       show(plantDetailController, sender: nil)
     }
    }
    
    private func setupView() {
        
        if let firstPhoto = animeItem.imagesURLs.first {
            PhotoRepository.downloadPhoto(from: firstPhoto) { image in
                DispatchQueue.main.async {
                    self.animeImageView.image = image
                }
            }
        }
        animeTitleLabel.text = animeItem.title
        animeEpisodesLabel.text = String(animeItem.episodes)
        descriptionTextView.text = animeItem.animeDescription
    }
    
    @objc func onEditTapped() {
         if let addAnimeItemViewController = storyboard?.instantiateViewController(identifier: AddAnimeItemViewController.identifier, creator: { coder in
            return AddAnimeItemViewController(coder: coder, animeItem: self.animeItem)
         }) {
            show(addAnimeItemViewController, sender: self)
         }
    }
    
    @IBAction func watchTapped(_ sender: Any) {
        if !animeItem.video.isEmpty {
            guard let videoURL = URL(string: animeItem.video) else { return }
            let video = AVPlayer(url: videoURL)
            let videoController = AVPlayerViewController()
            
            videoController.player = video
            
            self.present(videoController, animated: true) {
                video.play()
            }
        }
    }
    
}
