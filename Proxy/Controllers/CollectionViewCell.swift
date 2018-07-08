//
//  CollectionViewCell.swift
//  Proxy
//
//  Created by Josipa Lipovac on 08/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import FirebaseStorage

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageCollectionView: UIImageView!
    @IBOutlet weak var titleCollectionView: UILabel!
    
    var categorieList = [Category.clothing, Category.drinks, Category.food, Category.footwear, Category.mobile, Category.sport, Category.technology, Category.misc]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        imageCollectionView.image = nil
        titleCollectionView.text = ""
    }
   
    
    func setUpCollectionViewCell(listing: Listing) {
        titleCollectionView.text = "\(listing.title) - HRK \(String(format: "%.2f", listing.price))"
        Storage.storage().reference(withPath: "/images/\(listing.id).png").getData(maxSize: 15 * 1024 * 1024) { (data, error) in
            if let err = error {
                print(err)
            }
            else {
                self.imageCollectionView.image = UIImage(data: data!)
            }
        }
    }
}
