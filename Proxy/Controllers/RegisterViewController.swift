//
//  RegisterViewController.swift
//  Proxy
//
//  Created by Borna Relic on 07/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    func initialSetup() {
        createAccountButton.layer.cornerRadius = 22.5
    }

    @IBAction func createAccount(_ sender: UIButton) {
        print(usernameTextField.text! + " " + passwordTextField.text! + " " + emailTextField.text!)
        guard let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let user = response?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                print("User \(user) registered!")
            }
        }
    }
    
}
