//
//  ChatHelper.swift
//  Proxy
//
//  Created by Lukas Sestic on 13/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import Foundation
import FirebaseAuth

struct ChatChannel {
    let id: String
    let listingOwnerDisplayName: String
    let ownDisplayName: String
    let listingItem: String
    
    init(id: String, listingOwner: String, own: String, listingTitle: String) {
        self.id = id
        self.listingOwnerDisplayName = listingOwner
        self.ownDisplayName = own
        self.listingItem = listingTitle
    }
    
    init(listing: Listing) {
        var sortedIds = [listing.ownerId, Auth.auth().currentUser!.uid].sorted()
        self.init(id: "\(sortedIds[0])-\(sortedIds[1])", listingOwner: listing.ownerDisplayName, own: (Auth.auth().currentUser?.displayName)!, listingTitle: listing.title)
    }
    
    init(json: [String : Any]) {
        let id = json[ChatKeys.id] as! String
        let listingOwnerDisplayName = json[ChatKeys.listingOwnerDisplayName] as! String
        let ownDisplayName = json[ChatKeys.ownDisplayName] as! String
        let listingItem = json[ChatKeys.listingItem] as! String
        
        self.init(id: id, listingOwner: listingOwnerDisplayName, own: ownDisplayName, listingTitle: listingItem)
    }
    
    func databaseFormat() -> [String : Any] {
        return [ChatKeys.id : self.id, ChatKeys.listingItem : self.listingItem, ChatKeys.listingOwnerDisplayName : self.listingOwnerDisplayName, ChatKeys.ownDisplayName : self.ownDisplayName]
    }
    
}

struct ChatItem {
    let messageOrder: Int
    let text: String
    let senderName: String
    let senderId: String
}

struct Chat {
    let channel: ChatChannel
    let chatItems: [ChatItem]
    
    init(channel: ChatChannel, chatItems: [ChatItem]) {
        self.channel = channel
        self.chatItems = chatItems
    }
    
}
