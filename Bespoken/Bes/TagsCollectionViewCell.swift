//
//  TagsCollectionViewCell.swift
//  Bespoken
//
//  Created by Mohan on 12/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!{
        didSet{
            self.updateCell()
        }
    }
    func updateCell() {
        self.tagLabel.adjustsFontSizeToFitWidth = true
        self.tagLabel.layer.cornerRadius = 16
        self.tagLabel.backgroundColor = .random()
        self.backgroundColor = UIColor.clear
        self.backgroundView?.backgroundColor = UIColor.clear
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
