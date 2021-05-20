//
//  AddAnimeItemViewController.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/20/21.
//

import UIKit
import Firebase

class AddAnimeItemViewController: UIViewController {

    @IBOutlet weak var animeImageView: UIImageView!
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var episodesTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var addButton: UIButton!
    
    private let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Utilities.styleFilledButton(addButton)
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
