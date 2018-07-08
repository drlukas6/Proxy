//
//  ProfileViewController.swift
//  Proxy
//
//  Created by Borna Relic on 07/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var avatarColletionView: UICollectionView!
    @IBOutlet weak var avatarView: UIView!
    
    var profileListings = [Listing]()
    
    let cellId : String = "CellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        self.hideKeyboardWhenTappedAround()
        self.title = "Profile"
        UIView.animate(withDuration: 0) {
            self.avatarView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.size.height)
        }
        navigationController?.isNavigationBarHidden = true
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.cornerRadius = 56
        profileImage.clipsToBounds = true
        setImage()
        avatarColletionView.delegate = self
        avatarColletionView.dataSource = self
        avatarColletionView.register(UINib(nibName: "ProfileAvatarPickerCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        tableView.layer.cornerRadius = 17
        signOutButton.layer.cornerRadius = 17

        if let user = Auth.auth().currentUser {
            usernameLabel.text = user.displayName
            emailLabel.text = user.email
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: NibNames.profileTableViewCell, bundle: nil), forCellReuseIdentifier: cellId)
        
        //gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.chooseAvatar(_:)))
        tapGesture.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tapGesture)
    }
    
    func setImage() {
        if let user = Auth.auth().currentUser {
            Storage.storage().reference(withPath: "/userAvatar/\(user.uid).png").getData(maxSize: 15 * 1024 * 1024) { (data, error) in
                if let err = error {
                    print(err)
                    self.profileImage.image = UIImage(named: "prof")
                }
                else {
                    if let imageData = data {
                        self.profileImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    @objc func chooseAvatar(_ sender: Any) {
        print("tap")
        
        UIView.animate(withDuration: 0.75) {
            self.avatarView.transform = .identity
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileListings = [Listing]()
        self.navigationController?.isNavigationBarHidden = true
        
        DatabaseHelper.init().getListingsBy(condition: DatabaseHelper.byOwner, comparison: Auth.auth().currentUser!.uid) { (response) in
            self.profileListings = response.flatMap { Listing(json: $0) }
            self.tableView.reloadData()
        }
    }
    
    func updateTableData() {
        profileListings = [Listing]()
        
        DatabaseHelper.init().getListingsBy(condition: DatabaseHelper.byOwner, comparison: Auth.auth().currentUser!.uid) { (response) in
            self.profileListings = response.flatMap { Listing(json: $0) }
            self.tableView.reloadData()
        }
    }
}

extension ProfileViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileTableViewCell
        
        cell.setupCell(listing: profileListings[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileListings.count
    }
}

extension ProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let listing = profileListings[indexPath.row]
        let listingController = ListingViewController()
        listingController.listing = listing
        navigationController?.pushViewController(listingController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DatabaseHelper.init().deleteListing(listing: profileListings[indexPath.row], tableView: tableView)
        }
    }
}

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileAvatarPickerCell
        
        cell.setupCell(index: indexPath.row)
        
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: 75, height: 75)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ProfileAvatarPickerCell
        self.profileImage.image = selectedCell.avatarImage.image
        if let user = Auth.auth().currentUser {
            let imageReference = Storage.storage().reference().child("userAvatar/\(user.uid).png")
            if let image = self.profileImage.image, let dataImage = UIImagePNGRepresentation(image) {
                imageReference.putData(dataImage)
            }
        }
        UIView.animate(withDuration: 0.75) {
            self.avatarView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.size.height)
        }
    }
    
    
}

