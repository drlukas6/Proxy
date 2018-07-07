//
//  SearchTableViewCell.swift
//  Proxy
//
//  Created by Josipa Lipovac on 07/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var categorieCollectionView: UICollectionView!
    @IBOutlet weak var categorieTitle: UILabel!
    
    var listings: [Listing] = [] {
        didSet {
            categorieCollectionView.reloadData()
        }
    }
    var categorieList = [Category.clothing, Category.drinks, Category.food, Category.footwear, Category.mobile, Category.sport, Category.technology, Category.misc]
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialSetup() {
        categorieCollectionView.delegate = self
        categorieCollectionView.dataSource = self
        categorieCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionId")
    }
    
    func setUpTableViewCell(category: Category) {
        self.categorieTitle.text = category.rawValue
        
        DatabaseHelper.init().getListingsBy(condition: DatabaseHelper.byCategory, comparison: categorieTitle.text!) { (response) in
            self.listings = response.flatMap { Listing(json: $0) }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categorieCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionId", for: indexPath) as! CollectionViewCell
        if listings.count > 4  {
            cell.setUpCollectionViewCell(listing: listings[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: 200, height: 200)
        return cellSize
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
}
