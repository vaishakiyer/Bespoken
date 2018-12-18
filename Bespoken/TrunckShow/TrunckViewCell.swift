//
//  TrunckViewCell.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 23/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

protocol TrunckViewDelegate{
    
    func buttonPreviewPressed(sender: TrunckViewCell)
    func scanButtonPressed(sender: TrunckViewCell)
    
}

class TrunckViewCell: UICollectionViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var scannerButton: UIButton!
    @IBOutlet weak var bkgImage: UIImageView!
    
    var delegate : TrunckViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        scannerView.layer.borderWidth = 0.5
//        scannerView.layer.borderColor = UIColor.white.cgColor
//        scannerView.roundCorners(corners: .allCorners, radius: 6)
        outerView.roundCorners(corners: .allCorners, radius: 24)
        
        previewButton.addTarget(self, action: #selector(previewPressed), for: .touchUpInside)
        
        scannerButton.addTarget(self, action: #selector(scanPressed), for: .touchUpInside)
        // Initialization code
    }
    
    
   @objc func previewPressed(){
        delegate?.buttonPreviewPressed(sender: self)
    }

    @objc func scanPressed(){
        delegate?.scanButtonPressed(sender: self)
    }
}
