//
//  sizeChartCell.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 28/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class sizeChartCell: UICollectionViewCell {
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var sizeType: UILabel!
    @IBOutlet weak var sizeNum1: UILabel!
    @IBOutlet weak var sizeNum2: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        innerView.roundCorners(corners: .allCorners, radius: 6)
        
        innerView.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true)
        
        // Initialization code
    }

}
