//
//  DummyContent.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 20/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import Foundation

/*

func GifAnimation(){
    
    GifImgView.animationImages = loginGif?.images
    // Set the duration of the UIImage
    GifImgView.animationDuration = loginGif!.duration
    // Set the repetitioncount
    GifImgView.animationRepeatCount = 0
    // Start the animation
    GifImgView.startAnimating()
    
    
    var values = [CGImage]()
    for image in loginGif!.images! {
        values.append(image.cgImage!)
    }
    
    // Create animation and set SwiftGif values and duration
    let animation = CAKeyframeAnimation(keyPath: "contents")
    animation.calculationMode = CAAnimationCalculationMode.discrete
    animation.duration = loginGif!.duration
    animation.values = values
    // Set the repeat count
    animation.repeatCount = 0
    // Other stuff
    animation.isRemovedOnCompletion = false
    animation.fillMode = CAMediaTimingFillMode.forwards
    // Set the delegate
    animation.delegate = self
    GifImgView.layer.add(animation, forKey: "animation")
}


func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    
    if flag{
        UIView.transition(with: optionCollection, duration: 2, options: .transitionFlipFromLeft, animations: {
            self.optionCollection.isHidden = false
            self.optionCollection.backgroundColor = UIColor.clear
        }, completion: nil)
        
        
    }
    
}
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 
 measurementSlider.minimumValue = 0
 measurementSlider.maximumValue = 64
 measurementSlider.setThumbImage(UIImage(named: "Symbol 2 – 1"), for: .normal)
 
 measurementSlider.addTarget(self, action: #selector(updateLinearProgressView), for: .valueChanged)
 
 
 // Do any additional setup after loading the view.
 }
 
 
 @objc func updateLinearProgressView(sender: UISlider) {
 
 let step = 5
 let roundedValue = round(sender.value / step) * step
 sender.value = roundedValue
 valueLabel.text = sender.value.description
 }
 
 
 
*/
