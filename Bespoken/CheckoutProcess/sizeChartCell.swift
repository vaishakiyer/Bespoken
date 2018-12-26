//
//  sizeChartCell.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 28/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

protocol ButtonTouchDelegate {
    
    func button1Pressed(sender: sizeChartCell)
    func button2Pressed(sender: sizeChartCell)
    
}

class sizeChartCell: UICollectionViewCell {
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var sizeType: UILabel!
    @IBOutlet weak var sizeNum1: UILabel!
    @IBOutlet weak var sizeNum2: UILabel!
    @IBOutlet weak var sizeBtn1: UIButton!
    @IBOutlet weak var sizeBtn2: UIButton!
    
    var delegate: ButtonTouchDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        innerView.roundCorners(corners: .allCorners, radius: 6)
        
        innerView.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true)
        
        sizeBtn1.addTarget(self, action: #selector(buttonOnePressed), for: .touchUpInside)
        sizeBtn2.addTarget(self, action: #selector(buttonTwoPressed), for: .touchUpInside)
        // Initialization code
    }

    @objc func buttonOnePressed(){
        delegate?.button1Pressed(sender: self)
    }
    
    @objc func buttonTwoPressed(){
        delegate?.button2Pressed(sender: self)
    }
    
}
