//
//  SearchTableViewCell.swift
//  Proxy
//
//  Created by Josipa Lipovac on 07/06/2018.
//  Copyright © 2018 ruaziosteam. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var categorieCollectionView: UICollectionView!
    @IBOutlet weak var categorieTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        categorieCollectionView.delegate = dataSourceDelegate
        categorieCollectionView.dataSource = dataSourceDelegate
        categorieCollectionView.tag = row
        categorieCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        get {
            return categorieCollectionView.contentOffset.x
        }
        
        set {
            categorieCollectionView.contentOffset.x = newValue
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
