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
    }
    
    func resetValues() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @objc func loginWithUser() {
        guard let email = emailTextField.text, let password = emailTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let user = response?.user {
                print("User \(user) logged in!")
                let searchViewController = SearchViewController()
                self.navigationController?.pushViewController(searchViewController, animated: true)
            }
        }
    }
    
    @objc func registerUser() {
        let registerViewController = RegisterViewController()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }

    

}
