//
//  WishlistTableViewCell.swift
//  Bespoken
//
//  Created by Mohan on 27/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

protocol WishlistCollectionViewDelegate {
    func didSelectWishlistProduct(product : Product)
}
class WishlistTableViewCell: UITableViewCell {

    @IBOutlet var wishlistCollectionView: UICollectionView!
    var wishlistProducts : [Product]?{
        didSet{
            self.wishlistCollectionView.reloadData()
        }
    }
    var delegate : WishlistCollectionViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.wishlistCollectionView.delegate = self
        self.wishlistCollectionView.dataSource = self
//        if  self.wishlistCollectionView.collectionViewLayout == UICollectionViewFlowLayout{
//            self.wishlistCollectionView.collectionViewLayou
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectWishlistProduct(product: wishlistProducts![indexPath.row])
    }
}

extension WishlistTableViewCell: UICollectionViewDelegateFlowLayout{
    
}
