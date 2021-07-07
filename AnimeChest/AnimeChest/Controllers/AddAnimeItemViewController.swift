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
    static let identifier = String(describing: AddAnimeItemViewController.self)

    @IBOutlet weak var animeImageView: UIImageView!

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var episodesTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    private let ref = Database.database().reference()
    private let storageRef = Storage.storage().reference()
    var uploadedVideoUrl: URL? = nil
    var picker = UIImagePickerController()


    private var finalItem = AnimeItem(title: "", episodes: -1, animeDescription: "", video: "", imagesURLs: [""], mapX: -1, mapY: -1)
    private var tempArray = [String]()
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init?(coder: NSCoder, animeItem: AnimeItem) {
        finalItem = animeItem
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if finalItem.ref != nil {
            loadEditUI()
            addButton.isHidden = true
        }
        
        Utilities.styleFilledButton(saveChangesButton)
        Utilities.styleFilledButton(addButton)
        addPhotoButton.layer.shadowColor = UIColor(red: 128, green: 128, blue: 128, alpha: 0.50).cgColor
        addPhotoButton.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        addPhotoButton.layer.shadowOpacity = 1.0
        addPhotoButton.layer.shadowRadius = 0.0
        addPhotoButton.layer.masksToBounds = false
        addPhotoButton.layer.cornerRadius = 4.0
    }
    
    func loadEditUI() {
        titleTextField.text = finalItem.title
        episodesTextField.text = String(finalItem.episodes)
        descriptionTextView.text = finalItem.animeDescription
        
        if let firstPhoto = finalItem.imagesURLs.first {
            PhotoRepository.downloadPhoto(from: firstPhoto) { image in
                DispatchQueue.main.async {
                    self.animeImageView.image = image
                }
            }
        }
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
            if finalItem.video != "" {
                if let uploadedVideoURL = uploadedVideoUrl?.absoluteString {
                    finalItem.video = uploadedVideoURL
                }
            } else {
                finalItem.video = uploadedVideoUrl?.absoluteString ?? ""
            }
            if finalItem.imagesURLs == [""] {
                finalItem.imagesURLs = tempArray
            } else if !tempArray.isEmpty {
                finalItem.imagesURLs = tempArray
            }
            return finalItem
        } else { return nil }
    }
    
    func addAnimeToDatabase(_ item: AnimeItem) {
        if item.ref == nil {
            let itemRef = ref.child(Constants.DatabaseReferences.AnimeChild).childByAutoId()
            
            itemRef.setValue(item.toAnyObject())
        } else {
            item.ref?.updateChildValues(item.toAnyObject() as! [AnyHashable : Any])
        }
    }

    @IBAction func addAnimeTapped(_ sender: Any) {
        
        guard let item = makeAnimeItem() else {
            return
        }
        
        addAnimeToDatabase(item)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPhotoTapped(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 5
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = self
        present(controller, animated: true)
    }
    
    @IBAction func saveChangesTapped(_ sender: Any) {
        guard let item = makeAnimeItem() else { return }
        addAnimeToDatabase(item)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addVideoTapped(_ sender: Any) {
        picker.delegate = self
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = false
        picker.videoExportPreset = "AVAssetExportPresetPassthrough"
        self.present(picker, animated: true)
    }
    
//    func setMainPhoto(photoUrl: String) {
//        guard let url = URL(string: photoUrl) else { return }
//        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
//            if let data = data {
//                DispatchQueue.main.async {
//                    self!.animeImageView.image = UIImage(data: data)
//                }
//            }
//        }
//        dataTask.resume()
//    }
    
    func setMainPhotoTEST(for image: UIImage) {
        animeImageView.image = image
    }
}

extension AddAnimeItemViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if !results.isEmpty {
            for result in results {
                let itemProvider = result.itemProvider
                
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    
                        guard let image = image as? UIImage else { return }
                        
                        DispatchQueue.main.async {
                            guard let data = image.jpegData(compressionQuality: 0.1) else { return }
                            PhotoRepository.uploadPhoto(data: data) { (url) in
                                self?.tempArray.append(url)
                            }
                        }
                    }
                }
            }
        
            results[0].itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let image = image as? UIImage else { return }
                DispatchQueue.main.async {
                    self?.setMainPhotoTEST(for: image)
                }
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddAnimeItemViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let videoUrl = info[.mediaURL] as? URL
        let ref = storageRef.child(videoUrl?.relativeString ?? "video")
        let metadata = StorageMetadata()
        metadata.contentType = "video/quicktime"
        
        do {
            if let videoData = NSData(contentsOf: videoUrl!) as Data? {
                _ = ref.putData(videoData, metadata: metadata, completion: { metadata, error in
                    if error != nil {
                        // Error uploading video
                    }
                    
                    ref.downloadURL { (URL, err) in
                        guard let downloadUrl = URL else {
                            // Failed to get url
                            return
                        }
                        print("upload videk \(downloadUrl)")
                        self.uploadedVideoUrl = downloadUrl
                    }
                    return
                })
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


extension AddAnimeItemViewController: UINavigationControllerDelegate {
    
}
