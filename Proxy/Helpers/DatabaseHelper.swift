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
    
    enum Condition {
        case category(category: Category)
        case title(title: String)
        case ownerId
    }
    
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
    
    func by(title: String, in listing: [String : Any]) -> Bool {
        return (listing[ListingKeys.title] as! String).contains(title)
    }
    
    func by(category: String, in listing: [String : Any]) -> Bool {
        return (listing[ListingKeys.category] as! String) == category
    }
    
    func by(ownerId: String, in listing: [String : Any]) -> Bool {
        return (listing[ListingKeys.ownerId] as! String) == ownerId
    }
    
    func getListingsBy(condition: Condition, completionHandler: @escaping ([[String : Any]]) -> () ) {
        var toReturn = [[String : Any]]()
        ListingsReference.observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            while let listingPreParsed = enumerator.nextObject() as? DataSnapshot, let parsedListing = listingPreParsed.value as? [String : Any] {
                switch condition {
                case .category(let category):
                    if (parsedListing[ListingKeys.category] as! String) == category.rawValue {
                        toReturn.append(parsedListing)
                    }
                case .title(let title):
                    if (parsedListing[ListingKeys.title] as! String).contains(title) {
                        toReturn.append(parsedListing)
                    }
                case .ownerId:
                    if (parsedListing[ListingKeys.ownerId] as! String) == Auth.auth().currentUser!.uid {
                        toReturn.append(parsedListing)
                    }
                }
            }
            completionHandler(toReturn)
        }
    }
}
