//
//  ChatViewController.swift
//  Proxy
//
//  Created by Lukas Sestic on 13/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    var channelReference: DatabaseReference!
    var channel: ChatChannel! {
        didSet {
            self.title = channel.listingItem
        }
    }
    var messageRef: DatabaseReference!
    
    var messages = [JSQMessage]()
    var newMessageRefHandle: DatabaseHandle?
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        navigationController?.isNavigationBarHidden = false
        outgoingBubbleImageView = setupOutgoingMessage()
        incomingBubbleImageView = setupIncomingBubble()
        messageRef = channelReference.child("messages")
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        observeMessages()
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        cell.textView?.textColor = UIColor.white
        
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        itemRef.setValue(messageItem) //
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        
        finishSendingMessage() // 5
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return messages[indexPath.item].senderId == self.senderId ? outgoingBubbleImageView : incomingBubbleImageView
    }
    
    func setupOutgoingMessage() -> JSQMessagesBubbleImage {
        let bubbleImage = JSQMessagesBubbleImageFactory()
        return bubbleImage!.outgoingMessagesBubbleImage(with: UIColor(named: "trafficLightGreen"))
    }
    func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor(named: "trafficLightYellow"))
    }
    
    func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    private func observeMessages() {
        messageRef = channelReference!.child("messages")
        // 1.
        let messageQuery = messageRef.queryLimited(toLast:25)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                // 4
                self.addMessage(withId: id, name: name, text: text)
                
                // 5
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
    }
}
