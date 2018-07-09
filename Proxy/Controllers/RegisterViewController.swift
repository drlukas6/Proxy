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

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var passwordRequired: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func initialSetup() {
        self.hideKeyboardWhenTappedAround() 
        self.title = "Register"
        createAccountButton.layer.cornerRadius = 22.5
    }

    @IBAction func createAccount(_ sender: UIButton) {
        guard let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            showToast(message: "All fields required")
            return
        }
        if username.trimmingCharacters(in: .whitespaces) == "", email.trimmingCharacters(in: .whitespaces) == "", password.trimmingCharacters(in: .whitespaces) == "" {
            showToast(message: "All fields required")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (response, error) in

            if let error = error {
                print(error.localizedDescription)
                self.passwordRequired.isHidden = false
            }
            if let user = response?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                        print("User \(user.displayName) registered!")
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                
            }
        }
    }
    
    
}
