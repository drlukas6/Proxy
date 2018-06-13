//
//  DatabaseHelper.swift
//  Proxy
//
//  Created by Lukas Sestic on 13/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct DatabaseHelper {
    let BaseReference = Database.database().reference()
    var ChatsReference: DatabaseReference {
        return BaseReference.child("Chat")
    }
    var ListingsReference: DatabaseReference {
        return BaseReference.child("Listings")
    }
    
    func createBasicListing() {
        let listing = Listing(title: "Audi", owner: "NF89432NF2923", ownerDisplayName: "Adolf", price: 999, description: "foo", imageData: [], location: "-1.492, 2.423")
        ListingsReference.child(listing.id).setValue(listing.databaseFormat())
    }
}
