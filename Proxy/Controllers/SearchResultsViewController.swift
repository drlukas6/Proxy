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
    
    
}
