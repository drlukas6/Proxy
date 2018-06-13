//
//  AddListingViewController.swift
//  Proxy
//
//  Created by Borna Relic on 13/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit

class AddListingViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var addImagesButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleTextField.text = ""
        priceTextField.text = ""
        descriptionTextField.text = ""
    }
    
    func setupView() {
        addImagesButton.layer.cornerRadius = 20
    }

    @IBAction func addImages(_ sender: Any) {
    }
}
