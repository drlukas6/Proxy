//
//  PropertyKeys.swift
//  Proxy
//
//  Created by Josipa Lipovac on 07/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

//LoginRegister text Field constraints: 16 up,left, right. Height = 40
//Login Button height = 40
//Register Button height = 10

import Foundation

struct NibNames {
    static let logIn = "LogInView"
    static let register = "RegisterView"
    static let search = "SearchView"
    static let searchTableCell = "SearchTableViewCell"
    static let searchResultTableViewCell = "SearchResultTableViewCell"
    static let profileTableViewCell = "ProfileTableViewCell"
}

struct ListingKeys {
    static let id = "id"
    static let title = "title"
    static let ownerId = "ownerId"
    static let ownerDisplayName = "ownerDisplayName"
    static let price = "price"
    static let description = "description"
    static let imageData = "imageData"
    static let location = "location"
    static let category = "category"
    static let date = "date"
}

struct ChatKeys {
    static let id = "id"
    static let listingOwnerDisplayName = "listingOwnerDisplayName"
    static let ownDisplayName = "ownDisplayName"
    static let listingItem = "listingItem"
}


