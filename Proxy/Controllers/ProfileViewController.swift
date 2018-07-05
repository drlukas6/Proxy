//
//  ProfileViewController.swift
//  Proxy
//
//  Created by Borna Relic on 07/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewListingButton: UIButton!
    
    var profileListings = [Listing]()
    
    let cellId : String = "CellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        self.hideKeyboardWhenTappedAround()
        self.title = "Profile"
        navigationController?.isNavigationBarHidden = true
        addNewListingButton.layer.cornerRadius = 17
        tableView.layer.cornerRadius = 17
        if let user = Auth.auth().currentUser {
            usernameLabel.text = user.displayName
            emailLabel.text = user.email
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: NibNames.profileTableViewCell, bundle: nil), forCellReuseIdentifier: cellId)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileListings = [Listing]()
        
        DatabaseHelper.init().getListingsBy(condition: DatabaseHelper.byOwner, comparison: Auth.auth().currentUser!.uid) { (response) in
            for json in response {
                self.profileListings.append(Listing(json: json))
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addNewListing(_ sender: Any) {
        let vc = AddListingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateTableData() {
        profileListings = [Listing]()
        
        DatabaseHelper.init().getListingsBy(condition: DatabaseHelper.byOwner, comparison: Auth.auth().currentUser!.uid) { (response) in
            for json in response {
                self.profileListings.append(Listing(json: json))
            }
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
}

