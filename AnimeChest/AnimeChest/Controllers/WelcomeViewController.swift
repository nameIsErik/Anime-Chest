//
//  ViewController.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/15/21.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginWithoutSignUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Utilities.styleHollowButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
    }


}

