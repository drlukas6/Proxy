//
//  ListingViewController.swift
//  Proxy
//
//  Created by Lukas Sestic on 15/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import MapKit

class ListingViewController: UIViewController {

    @IBOutlet weak var listingTitle: UILabel!
    @IBOutlet weak var listingOwner: UILabel!
    @IBOutlet weak var listingPrice: UILabel!
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var listingDescription: UITextView!
    @IBOutlet weak var listingLocation: MKMapView!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        listingImage.layer.cornerRadius = 20.0
        listingLocation.layer.cornerRadius = 20.0
        listingDescription.layer.cornerRadius = 20.0
        contactButton.layer.cornerRadius = contactButton.bounds.height / 2
    }


}
