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

protocol AnimationCompletedDelegate {
    
    func animationCompleted()
    
}

class CurateStyle: UIView,LTMorphingLabelDelegate{
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var titleLabel: LTMorphingLabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var word1: LTMorphingLabel!
    @IBOutlet weak var word2: LTMorphingLabel!
    @IBOutlet weak var word3: LTMorphingLabel!
    @IBOutlet weak var word4: LTMorphingLabel!
    @IBOutlet weak var word5: LTMorphingLabel!
    
    var delegate : AnimationCompletedDelegate?
    
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
        setup()
       // contentView.roundCorners(corners: .allCorners, radius: backgroundImage.frame.width / 2)
    }
    
    func setup() {
        
         word1.delegate = self
         word2.delegate = self
         word3.delegate = self
         word4.delegate = self
         word5.delegate = self
        
        word1.morphingDuration = 8
        word2.morphingDuration = 8
        word3.morphingDuration = 8
        word4.morphingDuration = 8
        word5.morphingDuration = 8
        
        
        word1.morphingEffect = .anvil
        word2.morphingEffect = .anvil
        word3.morphingEffect = .anvil
        word4.morphingEffect = .anvil
        word5.morphingEffect = .anvil
        
    }
    
    func updateUI(words: [String]){
        
        
        word1.text = words[0]
        word2.text = words[1]
        if words.count > 2{
             word3.text = words[2]
        }else if words.count > 3{
              word4.text = words[3]
        }else if words.count > 4{
            word5.text = words[4]
        }
       
    }

    func morphingDidComplete(_ label: LTMorphingLabel){
        
        if label == word2{
            delegate?.animationCompleted()
        }
        
        
    }
    
    
}
