//
//  SearchResultTableViewCell.swift
//  Proxy
//
//  Created by Lukas Sestic on 04/07/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import FirebaseStorage

class SearchResultTableViewCell: UITableViewCell {

    
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var listingTitle: UILabel!
    @IBOutlet weak var listingPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(listing: Listing) {
        listingTitle.text = listing.title
        let formattedPrice = String(format: "%.2f", listing.price)
        listingPrice.text = "HRK\(formattedPrice)"
        Storage.storage().reference(withPath: "/images/\(listing.id).png").getData(maxSize: 15 * 1024 * 1024) { (data, error) in
            if let err = error {
                print(err)
            }
            else {
                self.listingImage.image = UIImage(data: data!)
                self.listingImage.layer.cornerRadius = 15.0
            }
        }
    }
}
