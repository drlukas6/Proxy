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
import FirebaseStorage

struct DatabaseHelper {
    let BaseReference = Database.database().reference()
    
    var ChatsReference: DatabaseReference {
        return BaseReference.child("Chat")
    }
    var ListingsReference: DatabaseReference {
        return BaseReference.child("Listings")
    }
    
    func createBasicListing() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let listing = Listing(id: UUID().uuidString, title: "Audi", owner: "NF89432NF2923", ownerDisplayName: "Adolf", price: 999, description: "foo", imageData: [], location: "-1.492, 2.423", date: dateFormatter.string(from: Date()), category: Category.drinks)
        ListingsReference.child(listing.id).setValue(listing.databaseFormat())
    }
    
    func addToStorage(listing: Listing, data: Data?) {
        guard let data = data else { return }
        let imageReference = Storage.storage().reference().child("images/\(listing.id).png")
        imageReference.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
                return
            }
            imageReference.downloadURL(completion: { (url, error) in
                if let error = error {
                    print(error)
                    return
                }
                listing.imageData = [url!.absoluteString]
                self.ListingsReference.child(listing.id).setValue(listing.databaseFormat())
            })
        }
    }
    
    func getChatReference(for channel: ChatChannel) -> DatabaseReference {
        return ChatsReference.child(channel.id)
    }
    
    static func byTitle(title: String, in listing: [String : Any]) -> Bool {
        return (listing[ListingKeys.title] as! String).lowercased().contains(title.lowercased())
    }
    
    static func byCategory(category: String, in listing: [String : Any]) -> Bool {
        return (listing[ListingKeys.category] as! String) == category
    }
    
    static func byOwner(ownerId: String, in listing: [String : Any]) -> Bool {
        return (listing[ListingKeys.ownerId] as! String) == ownerId
    }
    
    func getListingsBy(condition: @escaping (_ condition: String,_ listing: [String : Any]) -> Bool, comparison: String, completionHandler: @escaping ([[String : Any]]) -> () ) {
        ListingsReference.observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            let childrenSnapshot = (enumerator.allObjects as! [DataSnapshot])
            let allParsedListings = childrenSnapshot.compactMap { $0.value as? [String : Any] }
            completionHandler(allParsedListings.filter({ (parsedListing) -> Bool in
                return condition(comparison, parsedListing)
            }))
        }
    }
    
    func deleteListing(listing: Listing, tableView: UITableView) {
        ListingsReference.child(listing.id).removeValue()
        Storage.storage().reference().child("images/\(listing.id).png").delete { (error) in
            if let error = error {
                print(error)
            }
            tableView.reloadData()
        }
    }
    
    func createChatChannel(channel: ChatChannel) {
        ChatsReference.child(channel.id).setValue(channel.databaseFormat())
    }
    
    func getYourChatChannels(completionHandler: @escaping ([[String : Any]]) -> () ) {
        ChatsReference.observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            let childrenSnapshot = (enumerator.allObjects as! [DataSnapshot])
            let allParsedChatChannels = childrenSnapshot.compactMap { $0.value as? [String : Any] }
            completionHandler(allParsedChatChannels.filter({ (parsedListing) -> Bool in
                (parsedListing[ChatKeys.id] as! String).contains(Auth.auth().currentUser!.uid)
            }))
        }
    }
}
