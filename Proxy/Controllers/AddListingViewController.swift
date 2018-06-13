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

class AddListingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var addImagesButton: UIButton!
    @IBOutlet weak var locationMap: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var imageUploadedLabel: UILabel!
    @IBOutlet weak var setLocationTextField: UITextField!
    
    var imageData : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupView() {
        setLocationTextField.delegate = self
        imageUploadedLabel.isHidden = true
        addImagesButton.layer.cornerRadius = 20
        submitButton.layer.cornerRadius = 20
        descriptionTextField.layer.cornerRadius = 5
        self.hideKeyboardWhenTappedAround()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let adress = setLocationTextField.text else {
            return
        }
        
        setLocationTextField.resignFirstResponder()
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = adress
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            if response == nil {
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
    
    @IBAction func addImages(_ sender: Any) {
        let image = UIImagePickerController ()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info [UIImagePickerControllerOriginalImage] as? UIImage {
            imageData = UIImagePNGRepresentation(image)
            self.imageUploadedLabel.text = "Image has been uploaded."
            self.imageUploadedLabel.isHidden = false
//            print(imageData?.base64EncodedString())
            //nesto
        }
        else {
            print("error: image did not load")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        let latitude = locationMap.annotations[0].coordinate.latitude
        let longitude = locationMap.annotations[0].coordinate.longitude

        guard let title = titleTextField.text, let description = descriptionTextField.text, let priceString = priceTextField.text, let price = Float(priceString) else { return }
        
        let listing = Listing(title: title, owner: (Auth.auth().currentUser?.uid)!, ownerDisplayName: (Auth.auth().currentUser?.displayName)!, price: price, description: description, imageData: [], location: latitude.description + "," + longitude.description, category: Category.clothing)
        
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
