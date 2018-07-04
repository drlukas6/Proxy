//
//  CollectionViewCell.swift
//  Proxy
//
//  Created by Josipa Lipovac on 08/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageCollectionView: UIImageView!
    @IBOutlet weak var titleCollectionView: UILabel!
    // @IBOutlet weak var imageCollectionView: UIImageView!
   // @IBOutlet weak var titleCollectionView: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   
    
    func setUpCollectionViewCell() {
        titleCollectionView.text = "test"
        imageCollectionView.image = UIImage(named: "losauto")

    }
}
