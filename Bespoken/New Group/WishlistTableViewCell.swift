//
//  WishlistTableViewCell.swift
//  Bespoken
//
//  Created by Mohan on 27/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class WishlistTableViewCell: UITableViewCell {

    @IBOutlet var wishlistCollectionView: UICollectionView!
    var wishlistProducts : [Product]?{
        didSet{
            self.wishlistCollectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.wishlistCollectionView.delegate = self
        self.wishlistCollectionView.dataSource = self
//        if  self.wishlistCollectionView.collectionViewLayout = UICollectionViewFlowLayout{
//            self.wishlistCollectionView.collectionViewLayout
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension WishlistTableViewCell : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.wishlistProducts!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.wishlistCollectionView.dequeueReusableCell(withReuseIdentifier: "WishlistCollectionViewCell", for: indexPath) as! WishlistCollectionViewCell
        cell.indexPath = indexPath
        cell.product = self.wishlistProducts![indexPath.row]
        return cell
    }
    
}
extension WishlistTableViewCell: UICollectionViewDelegate{

}

extension WishlistTableViewCell: UICollectionViewDelegateFlowLayout{
    
}
