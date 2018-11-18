//
//  OptionsViewCell.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 18/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class OptionsViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
        
       outerView.backgroundColor = UIColor.groupTableViewBackground
       outerView.roundCorners(corners: UIRectCorner.allCorners, radius: 16)
        // Initialization code
    }
    
    func updateLabelFrame() {
        let maxSize = CGSize(width: 150, height: 300)
        let size = titleLabel.sizeThatFits(maxSize)
        titleLabel.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: size)
    }

}
