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
    
    
    func textFieldsValid() -> Bool {
        
        if titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return false
        }
        
        if episodesTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return false
        }
        
        if descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return false
        }
        return true
    }
    
    func makeAnimeItem() -> AnimeItem? {
        var item = AnimeItem(title: "", episodes: -1, animeDescription: "", video: "", imagesURLs: [""], mapX: -1, mapY: -1)
        if textFieldsValid() {
            item.title = titleTextField.text!
            item.episodes = Int(episodesTextField.text!)!
            item.animeDescription = descriptionTextView.text
            return item
        } else { return nil }
    }
    
    func addAnimeToDatabase(_ item: AnimeItem) {
        let itemRef = ref.child(Constants.DatabaseReferences.AnimeChild).childByAutoId()
        
        itemRef.setValue(item.toAnyObject())
    }

    @IBAction func addAnimeTapped(_ sender: Any) {
        
        guard let item = makeAnimeItem() else {
            return
        }
        
        addAnimeToDatabase(item)
    }
    
}
