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
        navigationController?.isNavigationBarHidden = false
        self.title = listing.title
        listingImage.layer.cornerRadius = 20.0
        listingImage.layer.masksToBounds = true
        setImage()
        listingLocation.layer.cornerRadius = 20.0
        setLocation()
        listingDescription.layer.cornerRadius = 20.0
        listingDescription.text = listing.description
        if listing.ownerId == Auth.auth().currentUser!.uid {
            contactButton.isHidden = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ListingViewController.editListing))
        }
        else {
            contactButton.layer.cornerRadius = contactButton.bounds.height / 2
            contactButton.addTarget(self, action: #selector(startChat), for: .touchUpInside)
        }
        listingOwner.text = "From " + listing.ownerDisplayName
        listingPrice.text = "HRK" + String(format: "%.2f", listing.price)
    }
    
    @objc func editListing() {
        let vc = AddListingViewController()
        vc.listing = listing
        vc.delegat = self
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    @objc
    func startChat() {
        let channel = ChatChannel(listing: listing)
        let channelDbReference = DatabaseHelper.init().getChatReference(for: channel)
        channelDbReference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.childrenCount < 1 {
                DatabaseHelper.init().createChatChannel(channel: channel)
            }
            let chatVC = ChatViewController()
            chatVC.senderId = Auth.auth().currentUser!.uid
            chatVC.senderDisplayName = Auth.auth().currentUser?.displayName
            chatVC.channel = channel
            chatVC.channelReference = channelDbReference
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}

extension ListingViewController : UpdateListingDelegat {
    func udateListing (listing : Listing) {
        self.listing = listing
        initialSetup()
    }
}
