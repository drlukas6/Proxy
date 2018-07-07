//
//  SearchViewController.swift
//  Proxy
//
//  Created by Josipa Lipovac on 07/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableSearch: UITableView!
    
    var categorieList = [Category.clothing, Category.drinks, Category.food, Category.footwear, Category.mobile, Category.sport, Category.technology, Category.misc]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorieList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! SearchTableViewCell
        cell.setUpTableViewCell(category: categorieList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc
    func searchForListing() {
        var listings: [Listing] = []
        
        DatabaseHelper.init().getListingsBy(condition: DatabaseHelper.byTitle, comparison: searchTextField.text ?? "") { (response) in
            listings = response.flatMap { Listing(json: $0) }
            let searchResultsVC = SearchResultsViewController()
            searchResultsVC.searchResults = listings
            self.navigationController?.pushViewController(searchResultsVC, animated: true)
        }
    }
    
    
    
    
    func initialSetup() {
        self.hideKeyboardWhenTappedAround()
        
        searchTextField.layer.cornerRadius = 5.0
        
        tableSearch.dataSource = self
        tableSearch.delegate = self
        tableSearch.estimatedRowHeight = 100
        tableSearch.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "CellIdentifier")
        tableSearch.layer.cornerRadius = 15.0
        searchButton.addTarget(self, action: #selector(searchForListing), for: .touchUpInside)
    }
}



