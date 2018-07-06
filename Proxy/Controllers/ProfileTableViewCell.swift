//
//  ProfileTableViewCell.swift
//  Proxy
//
//  Created by Borna Relic on 07/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import FirebaseStorage

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell (listing : Listing) {
        itemTitleLabel.text = listing.title
        let now = Date()
        let endDate = now.addingTimeInterval(24 * 3600 * 17) //Obrisati nakon datum updatea
//        let endDate = listing.dateUpload.addingTimeInterval(30 * 3600 * 24)
//        if now < endDate {
//            let formatter = DateComponentsFormatter()
//            formatter.allowedUnits = [.day]
//            formatter.unitsStyle = .full
//            dateLabel.text = formatter.string(from: now, to: endDate)!
//        }
//        else {
//            dateLabel.text = "Expired"
//        }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day]
        formatter.unitsStyle = .full
        dateLabel.text = formatter.string(from: now, to: endDate)!

        Storage.storage().reference(withPath: "/images/\(listing.id).png").getData(maxSize: 15 * 1024 * 1024) { (data, error) in
            if let err = error {
                print(err)
            }
            else {
                self.itemImage.image = UIImage(data: data!)
            }
        }
    }
}
