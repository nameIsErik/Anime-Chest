//
//  PhotoCollectionViewController.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/29/21.
//

import UIKit

class PhotoCollectionViewController: UIViewController {
    static let identifier = String(describing: PhotoCollectionViewController.self)
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    private let isEditMode: Bool
    private let animeItem : AnimeItem
    var dataSource: UICollectionViewDiffableDataSource<[String], String>!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init?(coder: NSCoder, animeItem: AnimeItem, isEditMode: Bool) {
        self.animeItem = animeItem
        self.isEditMode = isEditMode
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditMode {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onDeleteTapped))
        }
        photoCollectionView.collectionViewLayout = configureCollectionViewLayout()
        configureDataSource()
        configureSnapshot(animeItem: animeItem)
    }
    
    
    @objc func onDeleteTapped() {
        let visibleCell = photoCollectionView.visibleCells[0]
        guard let  indexPath = photoCollectionView.indexPath(for: visibleCell),
              let  photoToDelete = dataSource.itemIdentifier(for: indexPath),
              let arrayIndex = animeItem.imagesURLs.firstIndex(of: photoToDelete)
              else { return }
        animeItem.imagesURLs.remove(at: arrayIndex)
        
        configureSnapshot(animeItem: animeItem)
        photoCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}

extension PhotoCollectionViewController {
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<[String], String>(collectionView: photoCollectionView) { (collectionView, indexPath, animeItem) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
                fatalError("Cannot create new cell")
            }
            
            PhotoRepository.downloadPhoto(from: animeItem) { image in
                DispatchQueue.main.async {
                    cell.animeImageView.image = image
                }
            }
            return cell
        }
    }
    
    func configureSnapshot(animeItem: AnimeItem) {
        var currentSnaphot = NSDiffableDataSourceSnapshot<[String], String>()
        
        currentSnaphot.appendSections([animeItem.imagesURLs])
        currentSnaphot.appendItems(animeItem.imagesURLs)
        self.dataSource.apply(currentSnaphot, animatingDifferences: false)
    }
}
