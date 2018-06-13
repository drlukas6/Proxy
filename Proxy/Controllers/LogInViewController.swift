//
//  LogInViewController.swift
//  Proxy
//
//  Created by Josipa Lipovac on 07/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var chat: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetValues()
    }

    func initialSetup() {
        loginButton.layer.cornerRadius = 22.5
        registerButton.addTarget(self, action: #selector(LogInViewController.registerUser), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(LogInViewController.loginWithUser), for: .touchUpInside)
        chat.addTarget(self, action: #selector(LogInViewController.testChat), for: .touchUpInside)
        self.hideKeyboardWhenTappedAround()
    }
    
    func resetValues() {
        emailTextField.text = ""
        passwordTextField.text = ""
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func loginWithUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let user = response?.user {
                print("User \(user) logged in!")
                let searchViewController = SearchViewController()
                let addListing = AddListingViewController()
                self.navigationController?.pushViewController(addListing, animated: true)
            }
        }
    }
    
    @objc func registerUser() {
        let registerViewController = RegisterViewController()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @objc func testChat() {
        DatabaseHelper.init().createBasicListing()
        let cVC = ChatViewController()
        self.present(cVC, animated: true, completion: nil)
    }
    
    

    

}
