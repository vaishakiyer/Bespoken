//
//  HomePageOptionCell.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 19/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class HomePageOptionCell: UICollectionViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var titleText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleText.roundCorners(corners: .allCorners, radius: 12)
        outerView.roundCorners(corners: .allCorners, radius: 16)
        // Initialization code
    }

}
