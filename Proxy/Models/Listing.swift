//
//  Listing.swift
//  Proxy
//
//  Created by Josipa Lipovac on 07/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import Foundation


class Listing {
    let title: String
    let ownerId: String
    let ownerDisplayName: String
    let price: Float
    let description: String
    let imageData: [Data]
    let location: String
    
    init(title: String, owner: String, ownerDisplayName: String, price: Float, description: String, imageData: [Data], location: String) {
        self.title = title
        self.ownerId = owner
        self.ownerDisplayName = ownerDisplayName
        self.price = price
        self.description = description
        self.imageData = imageData
        self.location = location
    }
}
