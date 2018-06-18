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
        self.init(id: "\(listing.ownerId)-\(String(describing: Auth.auth().currentUser?.uid))", listingOwner: listing.ownerDisplayName, own: (Auth.auth().currentUser?.displayName)!, listingTitle: listing.title)
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
