//
//  Listing.swift
//  Proxy
//
//  Created by Josipa Lipovac on 07/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import Foundation


class Listing {
    let id: String
    let title: String
    let ownerId: String
    let ownerDisplayName: String
    let price: Float
    let description: String
    let imageData: [Data]
    let location: String
    
    init(title: String, owner: String, ownerDisplayName: String, price: Float, description: String, imageData: [Data], location: String) {
        self.id = UUID().uuidString
        self.title = title
        self.ownerId = owner
        self.ownerDisplayName = ownerDisplayName
        self.price = price
        self.description = description
        self.imageData = imageData
        self.location = location
    }
    
    func databaseFormat() -> [String : Any] {
        var dataString: [String] {
            var tmp = [String]()
            for d in imageData {
                tmp.append(d.base64EncodedString())
            }
            return tmp
        }
        return [ListingKeys.title : self.title, ListingKeys.ownerId: self.ownerId, ListingKeys.ownerDisplayName : self.ownerDisplayName, ListingKeys.price: self.price, ListingKeys.description: self.description, ListingKeys.imageData: dataString, ListingKeys.location: self.location]
    }
}
