//
//  CurateStyle.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 19/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import Foundation
import UIKit
import LTMorphingLabel

class CurateStyle: UIView{
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var titleLabel: LTMorphingLabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var word1: LTMorphingLabel!
    @IBOutlet weak var word2: LTMorphingLabel!
    @IBOutlet weak var word3: LTMorphingLabel!
    @IBOutlet weak var word4: LTMorphingLabel!
    @IBOutlet weak var word5: LTMorphingLabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("CurateStyle", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
       // contentView.roundCorners(corners: .allCorners, radius: backgroundImage.frame.width / 2)
    }
    
    

    
}
