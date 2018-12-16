//
//  ResultsCollectionViewCell.swift
//  Bespoken
//
//  Created by Mohan on 13/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import AlamofireImage

class ResultsCollectionViewCell: UICollectionViewCell {
    var product : Product?{
        didSet{
            self.updateCell()
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    func updateCell() {
        self.imageView.af_setImage(withURL: (URL(string: product!.images[0])!))
        self.imageView.layer.shadowColor = UIColor.lightGray.cgColor
        self.imageView.layer.shadowRadius = 5
        self.imageView.layer.shadowOpacity = 1
        self.imageView.layer.shadowOffset = CGSize.zero
    }
}
