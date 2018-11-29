//
//  Homecenter1.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 20/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class Homecenter1: UIView {
    
    @IBOutlet var contentView: UIView!
   
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var firstName: UILabel!
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("Homecenter1", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        contentView.roundCorners(corners: .allCorners, radius: firstImageView.frame.width / 2)
        
       
        
    }
    
    
   

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
