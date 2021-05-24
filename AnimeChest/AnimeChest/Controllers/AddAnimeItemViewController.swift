//
//  AddAnimeItemViewController.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/20/21.
//

import UIKit
import Firebase
import PhotosUI

class AddAnimeItemViewController: UIViewController {

    @IBOutlet weak var animeImageView: UIImageView!

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var episodesTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    private let ref = Database.database().reference()
    private var finalItem = AnimeItem(title: "", episodes: -1, animeDescription: "", video: "", imagesURLs: [""], mapX: -1, mapY: -1)
    
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
        if textFieldsValid() {
            finalItem.title = titleTextField.text!
            finalItem.episodes = Int(episodesTextField.text!)!
            finalItem.animeDescription = descriptionTextView.text
            return finalItem
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
    
    @IBAction func addPhotoTapped(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 5
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func setMainPhoto(photoUrl: String) {
        let url = URL(string: photoUrl)!
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    self!.animeImageView.image = UIImage(data: data)
                }
            }
        }
        dataTask.resume()
    }
}

extension AddAnimeItemViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if !results.isEmpty {
            for result in results {
                let itemProvider = result.itemProvider
                
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    
                        guard let image = image as? UIImage else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            guard let data = image.jpegData(compressionQuality: 0.1) else {
                                print("Can not ")
                                return
                            }
                            PhotoRepository.uploadPhoto(data: data) { (url) in
                                self?.finalItem.imagesURLs.append(url)
                            }
                                        
                        }
                        
                    }
                }
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }
}
