//
//  InitialCurate.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 20/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import LTMorphingLabel

protocol InitialAnimationFinishDelegate {
    
    func initiateTheFiveWords()
    
}

class InitialCurate: UIView,LTMorphingLabelDelegate {

    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var label1: LTMorphingLabel!
    @IBOutlet weak var label2: LTMorphingLabel!
    @IBOutlet weak var label3: LTMorphingLabel!
    var delegate : InitialAnimationFinishDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("InitialCurate", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        setup()
        
    }
    
    func setup(){
        
        label1.delegate = self
        label2.delegate = self
        label3.delegate = self
        
        label1.morphingDuration = 10
        label2.morphingDuration = 10
        label3.morphingDuration = 10
        
        label1.morphingEffect = .anvil
        label2.morphingEffect = .anvil
        label3.morphingEffect = .anvil
        
        label1.textColor = .white
         label2.textColor = .white
         label3.textColor = .white
        
        label1.textAlignment = .center
        label2.textAlignment = .center
        label3.textAlignment = .center
        
        label1.text = ""
        label2.text = ""
        label3.text = ""
    }
    
    func updateUI(){
        
        label1.text = "CURATING YOUR"
        label2.text = "STYLE STATEMENT"
        label3.text = "NOW"
        
    }
    
    func morphingDidComplete(_ label: LTMorphingLabel){
        
        if label == label3{
            if label3.text == "NOW"{
                 delegate?.initiateTheFiveWords()
            }
           
        }
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
