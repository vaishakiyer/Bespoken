//
//  WishlistCollectionViewCell.swift
//  Bespoken
//
//  Created by Mohan on 27/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class WishlistCollectionViewCell: UICollectionViewCell {
    var product : Product?{
        didSet{
            self.updateCell()
        }
    }
    var indexPath : IndexPath?
    @IBOutlet var imageView: UIImageView!
    
    func updateCell() {
        
        self.imageView.af_setImage(withURL: (URL(string: product!.images[0])!),  imageTransition: .crossDissolve(1), completion : nil)
        self.imageView.layer.cornerRadius = 25
        self.imageView.layer.shadowColor = UIColor.lightGray.cgColor
        self.imageView.layer.shadowRadius = 5
        self.imageView.layer.shadowOpacity = 1
        self.imageView.layer.shadowOffset = CGSize.zero
    }

}
