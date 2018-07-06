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
    var title: String
    let ownerId: String
    let ownerDisplayName: String
    var price: Float
    var description: String
    var imageData: [String]
    var location: String
    var category: Category
    
    init(id: String, title: String, owner: String, ownerDisplayName: String, price: Float, description: String, imageData: [String], location: String, category: Category) {
        self.id = id
        self.title = title
        self.ownerId = owner
        self.ownerDisplayName = ownerDisplayName
        self.price = price
        self.description = description
        self.imageData = imageData
        self.location = location
        self.category = category
    }
    
    convenience init(json: [String : Any]) {
        let title = json[ListingKeys.title] as! String
        let owner = json[ListingKeys.ownerId] as! String
        let ownerDisplayName = json[ListingKeys.ownerDisplayName] as! String
        let price = json[ListingKeys.price] as! Float
        let description = json[ListingKeys.description] as! String
        let imageData = json[ListingKeys.imageData] as! [String]
        let location = json[ListingKeys.location] as! String
        let category = json[ListingKeys.category] as! String
        let id = json[ListingKeys.id] as! String
        
        self.init(id: id, title: title, owner: owner, ownerDisplayName: ownerDisplayName, price: price, description: description, imageData: imageData, location: location, category: Category(category: category))
    }
    
    func databaseFormat() -> [String : Any] {
        return [ListingKeys.id: self.id, ListingKeys.title : self.title, ListingKeys.ownerId: self.ownerId, ListingKeys.ownerDisplayName : self.ownerDisplayName, ListingKeys.price: self.price, ListingKeys.description: self.description, ListingKeys.imageData: imageData, ListingKeys.location: self.location, ListingKeys.category: self.category.rawValue]
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
    
    init(category: String) {
        switch category {
        case "Food":
            self = .food
        case "Drinks":
            self = .drinks
        case "Mobile":
            self = .mobile
        case "Technology":
            self = .technology
        case "Clothing":
            self = .clothing
        case "Misc.":
            self = .misc
        case "Sport":
            self = .sport
        default:
            self = .footwear
        }
    }
    
    func getAll() -> [Category] {
        return [Category.food, Category.drinks, Category.mobile, Category.technology, Category.clothing, Category.misc, Category.sport, Category.footwear]
    }
}
