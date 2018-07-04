//
//  ListingViewController.swift
//  Proxy
//
//  Created by Lukas Sestic on 15/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseStorage

class ListingViewController: UIViewController {

    @IBOutlet weak var listingTitle: UILabel!
    @IBOutlet weak var listingOwner: UILabel!
    @IBOutlet weak var listingPrice: UILabel!
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var listingDescription: UITextView!
    @IBOutlet weak var listingLocation: MKMapView!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var listing: Listing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        listingImage.layer.cornerRadius = 20.0
        listingImage.layer.masksToBounds = true
        listingLocation.layer.cornerRadius = 20.0
        listingDescription.layer.cornerRadius = 20.0
        contactButton.layer.cornerRadius = contactButton.bounds.height / 2
        
        listingTitle.text = listing.title
        listingOwner.text = "From " + listing.ownerDisplayName
        listingPrice.text = "HRK" + String(format: "%.2f", listing.price)
        listingDescription.text = listing.description
        
        setImage()
        setLocation()
    }
    
    func setImage() {
        Storage.storage().reference(withPath: "/images/\(listing.id).png").getData(maxSize: 15 * 1024 * 1024) { (data, error) in
            if let err = error {
                print(err)
            }
            else {
                self.listingImage.image = UIImage(data: data!)
            }
        }
    }
    
    
    func setLocation() {
        let coordinates = listing.location.split(separator: ",")
        let annotaion = MKPointAnnotation()
        annotaion.coordinate = CLLocationCoordinate2DMake(Double(coordinates[0])!, Double(coordinates[1])!)
        listingLocation.addAnnotation(annotaion)
        
        let location = CLLocationCoordinate2DMake(Double(coordinates[0])!, Double(coordinates[1])!)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(location, span)
        self.listingLocation.setRegion(region, animated: true)
    }
    
    
    
    @objc func startChat() {
        let channel = ChatChannel(listing: listing)
        let channelDbReference = DatabaseHelper.init().getChatReference(for: channel)
        let chatVC = ChatViewController()
        chatVC.senderId = Auth.auth().currentUser!.uid
        chatVC.senderDisplayName = Auth.auth().currentUser?.displayName
        chatVC.channel = channel
        chatVC.channelReference = channelDbReference
    }


}
