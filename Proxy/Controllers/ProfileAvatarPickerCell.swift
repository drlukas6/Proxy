//
//  ProfileAvatarPickerCell.swift
//  Proxy
//
//  Created by Borna Relic on 07/07/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import FirebaseStorage

class ProfileAvatarPickerCell: UICollectionViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImage.isUserInteractionEnabled = true
    }
    
    func setupCell (index: Int) {
        setImage(index: index)
    }
    
    func setImage(index: Int) {
        Storage.storage().reference(withPath: "/avatar/\(index + 1).png").getData(maxSize: 15 * 1024 * 1024) { (data, error) in
            if let err = error {
                print(err)
            }
            else {
                if let imageData = data {
                    self.avatarImage.image = UIImage(data: imageData)
                }
            }
        }
    }

}
