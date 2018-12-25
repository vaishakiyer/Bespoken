//
//  SizeSliderCell.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 01/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class SizeSliderCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sliderValue: UILabel!
    @IBOutlet weak var mySlider: UISlider!
    
    var valueHandler: ((_ val: String) -> Void)!
    
    let step :Float = 8
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mySlider.minimumValue = 0
        mySlider.maximumValue = 64
       mySlider.setThumbImage(UIImage(named: "Group 437"), for: .normal)
        
        mySlider.addTarget(self, action: #selector(updateLinearProgressView), for: .valueChanged)
        
        titleLabel.roundCorners(corners: .allCorners, radius: 12)
         sliderValue.roundCorners(corners: .allCorners, radius: 12)
        
   //  sliderValue.dropShadow(color: .groupTableViewBackground, opacity: 1, offSet: CGSize.zero, radius: 0.5, scale: true)
          
        
        // Initialization code
    }
    
    
    @objc func updateLinearProgressView(sender: UISlider) {
        
        let roundedValue = (sender.value / step) * step
        sender.value = roundedValue
       
        sliderValue.text =  String(format: "%.1f", sender.value)
        let storeVal = String(format: "%.1f", sender.value)
        self.valueHandler(storeVal)
    }

}
