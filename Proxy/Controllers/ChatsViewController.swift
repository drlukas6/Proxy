//
//  ChatsViewController.swift
//  Proxy
//
//  Created by Lukas Šestić on 05/07/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatsViewController: UIViewController {

    @IBOutlet weak var chatsTableView: UITableView!
    var chats: [ChatChannel]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshChatChannels()
    }

    func initialSetup() {
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        chatsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChannelsId")
    }

    func refreshChatChannels() {
        DatabaseHelper.init().getYourChatChannels { (response) in
            var channels = [ChatChannel]()
            for json in response {
                channels.append(ChatChannel(json: json))
            }
            self.chats = channels
            self.chatsTableView.reloadData()
        }
    }
}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: "ChannelsId")!
        setupCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func setupCell(cell: UITableViewCell, indexPath: IndexPath) {
        let channel = chats[indexPath.row]
        if channel.listingOwnerDisplayName == Auth.auth().currentUser!.displayName! {
            cell.textLabel?.text = channel.ownDisplayName
        }
        else {
            cell.textLabel?.text = channel.listingOwnerDisplayName
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channelDbReference = DatabaseHelper.init().getChatReference(for: chats[indexPath.row])
        let chatVC = ChatViewController()
        chatVC.senderId = Auth.auth().currentUser!.uid
        chatVC.senderDisplayName = Auth.auth().currentUser?.displayName
        chatVC.channel = chats[indexPath.row]
        chatVC.channelReference = channelDbReference
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
}
