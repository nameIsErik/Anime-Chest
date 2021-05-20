//
//  CollectionViewController.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/17/21.
//

import UIKit
import Firebase

class CollectionViewController: UIViewController {

    @IBOutlet weak var animeCollectionView: UICollectionView!
    
    var ref: DatabaseReference!
    var dataSource: UICollectionViewDiffableDataSource<AnimeCollection, AnimeItem>!
    var animeItems: [AnimeItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.navigationController?.isNavigationBarHidden = true
        setupView()
    }
    
    private func setupView() {
        animeCollectionView.delegate = self
        animeCollectionView.collectionViewLayout = configureCollectionViewLayout()
        configureDatabase()
        configureDataSource()
    }

    @IBAction func addTapped(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.CollectionToAdd, sender: nil)
    }
    
}

// MARK: - Collection View -

extension CollectionViewController {
    
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
   
        
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<AnimeCollection, AnimeItem>(collectionView: animeCollectionView) { (collectionView, indexPath, animeItem) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnimeItemCell.reuseIdentifier, for: indexPath) as? AnimeItemCell else {
                fatalError("Cannot create new cell")
            }
            
            cell.titleLabel.text = animeItem.title
            cell.episodesLabel.text = String(animeItem.episodes)
            
            return cell
        }
    }
    
    func configureSnapshot(animeCollection: AnimeCollection) {
        var currentSnapshot = NSDiffableDataSourceSnapshot<AnimeCollection, AnimeItem>()
        
        currentSnapshot.appendSections([animeCollection])
        currentSnapshot.appendItems(animeCollection.animeItems)
        self.dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
}

// MARK: - Configure Database -

extension CollectionViewController {
    
    func configureDatabase() {
        ref = Database.database().reference()
        
        ref.child(Constants.DatabaseReferences.AnimeChild).observe(.value) { snapshot in
            var items: [AnimeItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let animeItem = AnimeItem(snapshot: snapshot) {
                    items.append(animeItem)
                }
            }
            self.animeItems = items
            let collection = AnimeCollection(name: "AnimeCollection", animeItems: self.animeItems)
            self.configureSnapshot(animeCollection: collection)
        }
    }
}

// MARK: - UICollectionViewDelegate -

extension CollectionViewController: UICollectionViewDelegate {
    
}
