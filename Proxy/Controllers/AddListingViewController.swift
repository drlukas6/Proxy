//
//  AddListingViewController.swift
//  Proxy
//
//  Created by Borna Relic on 13/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseStorage

class AddListingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var addImagesButton: UIButton!
    @IBOutlet weak var locationMap: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    var imageData : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        titleTextField.text = ""
//        priceTextField.text = ""
//        descriptionTextField.text = ""
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupView() {
        addImagesButton.layer.cornerRadius = 20
        submitButton.layer.cornerRadius = 20
        descriptionTextField.layer.cornerRadius = 5
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func addImages(_ sender: Any) {
        let image = UIImagePickerController ()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.camera
        
        image.allowsEditing = false
        
        self.present(image, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info [UIImagePickerControllerOriginalImage] as? UIImage {
            imageData = UIImagePNGRepresentation(image)
//            print(imageData?.base64EncodedString())
            //nesto
        }
        else {
            print("error: image did not load")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func submit(_ sender: Any) {
        guard let title = titleTextField.text, let description = descriptionTextField.text, let priceString = priceTextField.text, let price = Float(priceString) else { return }
        
        let listing = Listing(title: title, owner: (Auth.auth().currentUser?.uid)!, ownerDisplayName: (Auth.auth().currentUser?.displayName)!, price: price, description: description, imageData: [], location: "-2,424213, 6.231535", category: Category.clothing)
        
        addToStorage(listing: listing, data: imageData)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func addToStorage(listing: Listing, data: Data?) {
        guard let data = data else {
            print("Error no data grabbed")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/\(listing.id).png")
        _ = imageRef.putData(data, metadata: nil, completion: { (metadata, error) in
            if error != nil  {
                print("error")
                return
            }
            else {
                imageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print (error)
                    }
                    else {
                        if let url = url {
                            listing.imageData = [url.absoluteString]
                            DatabaseHelper.init().ListingsReference.child(listing.id).setValue(listing.databaseFormat())
                        }
                    }
                })
            }
        })
    }
}
