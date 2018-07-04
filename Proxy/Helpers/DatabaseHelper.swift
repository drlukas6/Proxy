//
//  DatabaseHelper.swift
//  Proxy
//
//  Created by Lukas Sestic on 13/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct DatabaseHelper {
    let BaseReference = Database.database().reference()
    var ChatsReference: DatabaseReference {
        return BaseReference.child("Chat")
    }
    var ListingsReference: DatabaseReference {
        return BaseReference.child("Listings")
    }
    
    func createBasicListing() {
        let listing = Listing(id: UUID().uuidString, title: "Audi", owner: "NF89432NF2923", ownerDisplayName: "Adolf", price: 999, description: "foo", imageData: [], location: "-1.492, 2.423", category: Category.drinks)
        ListingsReference.child(listing.id).setValue(listing.databaseFormat())
    }
    
    func getChatReference(for channel: ChatChannel) -> DatabaseReference {
        return ChatsReference.child(channel.id)
    }
    
    func getListingsByCategory(category: Category, completionHandler: @escaping ([[String : Any]]) -> () ) {
        var toReturn = [[String : Any]]()
        ListingsReference.observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            while let listingPreParsed = enumerator.nextObject() as? DataSnapshot, let parsedListing = listingPreParsed.value as? [String : Any], let listingCategory = parsedListing[ListingKeys.category] as? String  {
                if listingCategory == category.rawValue {
                    toReturn.append(parsedListing)
                }
            }
            completionHandler(toReturn)
        }
    }
    
    func getListingsByName(name: String, completionHandler: @escaping ([[String : Any]]) -> () ) {
        var toReturn = [[String : Any]]()
        ListingsReference.observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            while let listingPreParsed = enumerator.nextObject() as? DataSnapshot, let parsedListing = listingPreParsed.value as? [String : Any], let listingTitle = parsedListing[ListingKeys.title] as? String  {
                if listingTitle.contains(name) {
                    toReturn.append(parsedListing)
                }
            }
            completionHandler(toReturn)
        }
    }
    
    func getListingByUserId(userId: String, completionHandler: @escaping ([[String : Any]]) -> () ) {
        var toReturn = [[String : Any]]()
        ListingsReference.observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            while let listingPreParsed = enumerator.nextObject() as? DataSnapshot, let parsedListing = listingPreParsed.value as? [String : Any], let listingOwner = parsedListing[ListingKeys.ownerId] as? String  {
                if listingOwner == Auth.auth().currentUser!.uid {
                    toReturn.append(parsedListing)
                }
            }
            completionHandler(toReturn)
        }
    }
    
    
}
