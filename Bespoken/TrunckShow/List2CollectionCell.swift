//
//  List2CollectionCell.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 18/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

protocol TrunckViewDelegate{
    
    func buttonPreviewPressed(sender: List2CollectionCell)
    func scanButtonPressed(sender: List2CollectionCell)
    
}

class List2CollectionCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var scannerButton: UIButton!
    
    var delegate : TrunckViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outerView.roundCorners(corners: .allCorners, radius: 16)
        playButton.addTarget(self, action: #selector(previewPressed), for: .touchUpInside)
        scannerButton.addTarget(self, action: #selector(scanPressed), for: .touchUpInside)
        titleLabel.isHidden = true
        // Initialization code
    }
    
    @objc func previewPressed(){
        delegate?.buttonPreviewPressed(sender: self)
    }
    
    @objc func scanPressed(){
        delegate?.scanButtonPressed(sender: self)
    }

}
