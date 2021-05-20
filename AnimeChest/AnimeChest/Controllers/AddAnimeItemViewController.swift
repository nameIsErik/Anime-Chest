//
//  AddAnimeItemViewController.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/20/21.
//

import UIKit

class AddAnimeItemViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
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
