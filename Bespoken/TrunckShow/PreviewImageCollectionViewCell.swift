//
//  PreviewImageCollectionViewCell.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 23/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import ImageSlideshow

protocol EnlargeImageDelegate {
    
    func openImage(sender: ImageSlideshow)
}

class PreviewImageCollectionViewCell: UICollectionViewCell {
    
    
  
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var countDownLabel: UILabel!
    var delegate: EnlargeImageDelegate?
    @IBOutlet weak var slideShow: ImageSlideshow!
    var imageList = [AlamofireSource](){
        didSet{
            updateImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // let releaseDateString = "2018-11-24 23:00:00"
        countDownLabel.isHidden = true
        slideShow.activityIndicator = DefaultActivityIndicator()
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        slideShow.pageIndicator = pageIndicator
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideShow.addGestureRecognizer(gestureRecognizer)
        // Initialization code
    }
    
    @objc func didTap() {
        
        delegate?.openImage(sender: slideShow)
        //slideShow.presentFullScreenController(from: self)
    }
   
    func updateImage(){
        slideShow.setImageInputs(imageList)
    }

}
