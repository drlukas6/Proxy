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


class AddListingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var addImagesButton: UIButton!
    @IBOutlet weak var locationMap: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var imageUploadedLabel: UILabel!
    @IBOutlet weak var setLocationTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var descriptionRequiredLabel: UILabel!
    @IBOutlet weak var imageRequiredLabel: UILabel!
    @IBOutlet weak var locationRequiredLabel: UILabel!
    @IBOutlet weak var priceRequiredLabel: UILabel!
    @IBOutlet weak var titleRequiredLabel: UILabel!
    
    var categorieList = [Category.clothing, Category.drinks, Category.food, Category.footwear, Category.mobile, Category.sport, Category.technology, Category.misc]
    
    var imageData : Data?
    var listing : Listing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        setLocationTextField.delegate = self
        titleTextField.delegate = self
        priceTextField.delegate = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.selectRow(3, inComponent: 0, animated: true)
        imageUploadedLabel.isHidden = true
        addImagesButton.layer.cornerRadius = 20.0
        submitButton.layer.cornerRadius = 20.0
        locationMap.layer.cornerRadius = 20.0
        descriptionTextField.layer.cornerRadius = 5.0
        self.hideKeyboardWhenTappedAround()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.tag == 1) {
            UIView.animate(withDuration: 0.5, animations: {
                self.titleLabel.isHidden = false
                self.titleLabel.textColor = UIColor.gray
            }, completion: nil)
        }
        else if textField.tag == 2 {
            UIView.animate(withDuration: 0.5, animations: {
                self.priceLabel.isHidden = false
                self.priceLabel.textColor = UIColor.gray
            }, completion: nil)
        }
        else if textField.tag == 3 {
            UIView.animate(withDuration: 0.5, animations: {
                self.locationLabel.isHidden = false
                self.locationLabel.textColor = UIColor.gray
            }, completion: nil)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            if textField.text?.trimmingCharacters(in: .whitespaces) == "" {
                UIView.animate(withDuration: 0.5, animations: {
                    self.titleLabel.isHidden = true
                }, completion: nil)
            }
            else {
                if titleRequiredLabel.isHidden == false {
                    UIView.animate(withDuration: 0.5) {
                        self.titleRequiredLabel.isHidden = true
                    }
                }
            }
        }
        else if textField.tag == 2 {
            if textField.text?.trimmingCharacters(in: .whitespaces) == "" {
                UIView.animate(withDuration: 0.5, animations: {
                    self.priceLabel.isHidden = true
                }, completion: nil)
            }
            else {
                if priceRequiredLabel.isHidden == false {
                    UIView.animate(withDuration: 0.5) {
                        self.priceRequiredLabel.isHidden = true
                    }
                }
            }
        }
        else if textField.tag == 3 {
            guard let adress = setLocationTextField.text else {
                return
            }
            
            if adress.trimmingCharacters(in: .whitespaces) == "" {
                UIView.animate(withDuration: 0.5, animations: {
                    self.locationLabel.isHidden = true
                }, completion: nil)
            }
            else {
                if locationRequiredLabel.isHidden == false {
                    UIView.animate(withDuration: 0.5) {
                        self.locationRequiredLabel.isHidden = true
                    }
                }
            }
            
            setLocationTextField.resignFirstResponder()
            
            let searchRequest = MKLocalSearchRequest()
            searchRequest.naturalLanguageQuery = adress
            
            let activeSearch = MKLocalSearch(request: searchRequest)
            
            activeSearch.start { (response, error) in
                if response == nil, let error = error {
                    print(error)
                    print("error, adress not found")
                }
                else {
                    let annotations = self.locationMap.annotations
                    self.locationMap.removeAnnotations(annotations)
                    
                    let longitude = response?.boundingRegion.center.longitude
                    let latitude = response?.boundingRegion.center.latitude
                    
                    if let longitude = longitude ,let latitude = latitude {
                        let annotation = MKPointAnnotation()
                        annotation.title = adress
                        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                        self.locationMap.addAnnotation(annotation)
                        
                        let location = CLLocationCoordinate2DMake(latitude, longitude)
                        let span = MKCoordinateSpanMake(0.01, 0.01)
                        let region = MKCoordinateRegionMake(location, span)
                        self.locationMap.setRegion(region, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func addImages(_ sender: Any) {
        let image = UIImagePickerController ()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info [UIImagePickerControllerOriginalImage] as? UIImage {
            if image.size.height > 1000 && image.size.height > 1000 {
                imageData = UIImagePNGRepresentation(image.resizeWithPercent(percentage: 0.1)!)
            }
            else {
                imageData = UIImagePNGRepresentation(image)
            }
            if imageData != nil, imageRequiredLabel.isHidden == false {
                UIView.animate(withDuration: 0.5) {
                    self.imageRequiredLabel.isHidden = true
                }
            }
            self.imageUploadedLabel.text = "Image has been uploaded."
            self.imageUploadedLabel.isHidden = false
        }
        else {
            print("error: image did not load")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        
        guard let title = titleTextField.text, let description = descriptionTextField.text, let priceString = priceTextField.text, let price = Float(priceString), locationMap.annotations.count != 0, let data = imageData else {
            showToast(message: "Fill in required informations!")
            if titleTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
                UIView.animate(withDuration: 0.5) {
                    self.titleRequiredLabel.isHidden = false
                }
            }
            if descriptionTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
                UIView.animate(withDuration: 0.5) {
                    self.descriptionRequiredLabel.isHidden = false
                }
            }
            if priceTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
                UIView.animate(withDuration: 0.5) {
                    self.priceRequiredLabel.isHidden = false
                }
            }
            if setLocationTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
                UIView.animate(withDuration: 0.5) {
                    self.locationRequiredLabel.isHidden = false
                }
            }
            if imageData == nil {
                UIView.animate(withDuration: 0.5) {
                    self.imageRequiredLabel.isHidden = false
                }
            }
            return
        }
        
        let latitude = locationMap.annotations[0].coordinate.latitude
        let longitude = locationMap.annotations[0].coordinate.longitude
        let categoryIndex = categoryPicker.selectedRow(inComponent: 0)
        let category = categorieList[categoryIndex]
        
        listing = Listing(id: UUID().uuidString,title: title, owner: (Auth.auth().currentUser?.uid)!, ownerDisplayName: (Auth.auth().currentUser?.displayName)!, price: price, description: description, imageData: [], location: latitude.description + "," + longitude.description, category: category)
        
        addToStorage(listing: listing!, data: imageData)
        
        resetView()
        tabBarController?.selectedIndex = 0
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
    
    //PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorieList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorieList[row].rawValue
    }
    
    func resetView() {
        titleLabel.text = ""
        priceLabel.text = ""
        descriptionTextField.text = ""
        setLocationTextField.text = ""
        imageData = nil
    }
}
