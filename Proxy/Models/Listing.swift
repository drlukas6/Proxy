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
    let imageData: [URL]
    let location: String
    let category: Category
    
    init(title: String, owner: String, ownerDisplayName: String, price: Float, description: String, imageData: [URL], location: String, category: Category) {
        self.id = UUID().uuidString
        self.title = title
        self.ownerId = owner
        self.ownerDisplayName = ownerDisplayName
        self.price = price
        self.description = description
        self.imageData = imageData
        self.location = location
        self.category = category
    }
    
    func databaseFormat() -> [String : Any] {
        return [ListingKeys.title : self.title, ListingKeys.ownerId: self.ownerId, ListingKeys.ownerDisplayName : self.ownerDisplayName, ListingKeys.price: self.price, ListingKeys.description: self.description, ListingKeys.imageData: imageData, ListingKeys.location: self.location, ListingKeys.category: self.category.rawValue]
    }
}

enum Category: String {
    case food = "Food"
    case drinks = "Drinks"
    case mobile = "Mobile"
    case technology = "Technology"
    case clothing = "Clothing"
    case misc = "Misc."
    case sport = "Sport"
    case footwear = "Footwear"
}
