//
//  ResultsCollectionViewCell.swift
//  Bespoken
//
//  Created by Mohan on 13/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import AlamofireImage
protocol ResultsCollectionViewCellDelegate {
    func didFinishLoadingImage(_ cell: UICollectionViewCell)
}
class ResultsCollectionViewCell: UICollectionViewCell {
    var product : Product?{
        didSet{
            self.updateCell()
        }
    }
    var delegate :ResultsCollectionViewCellDelegate?
    var indexPath : IndexPath?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var productTitle: UILabel!
    
    func updateCell() {
        
        self.imageView.af_setImage(withURL: (URL(string: product!.images[0])!),  imageTransition: .crossDissolve(1), completion: {(resopnse) in
            switch resopnse.result {
            case .success(let value):
                if self.product?.imageSizes[(self.product?.images[0])!] == nil{
                    self.product?.imageSizes[self.product!.images[0]] = CGSize(width : value.size.width , height : value.size.height)
                    self.delegate!.didFinishLoadingImage(self)
                    print(self.product?.imageSizes[self.product!.images[0]])
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            self.imageView.layer.shadowColor = UIColor.lightGray.cgColor
            self.imageView.layer.shadowRadius = 5
            self.imageView.layer.shadowOpacity = 1
            self.imageView.layer.shadowOffset = CGSize.zero
            self.imageView.layer.cornerRadius = 20 //self.imageView.frame.width/2
            self.productTitle.text = self.product?.title
            
        }
        )
    }
}
