//
//  CollectionViewController.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/17/21.
//

import UIKit

class CollectionViewController: UIViewController {

    @IBOutlet weak var animeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.navigationController?.isNavigationBarHidden = true
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
