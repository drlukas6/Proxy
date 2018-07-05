//
//  SearchResultsViewController.swift
//  Proxy
//
//  Created by Lukas Sestic on 04/07/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var searchResults: [Listing]!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        self.title = "Search Results"
        navigationController?.isNavigationBarHidden = false
        tableView.layer.cornerRadius = 15.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: NibNames.searchResultTableViewCell, bundle: nil), forCellReuseIdentifier: "SearchResultCellId")
    }
    
    

}


extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCellId") as! SearchResultTableViewCell
        cell.setup(listing: searchResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let listingVC = ListingViewController()
        listingVC.listing = searchResults[indexPath.row]
        
        navigationController?.pushViewController(listingVC, animated: true)
    }
    
    
}
