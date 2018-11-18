//
//  LoginViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 18/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,CAAnimationDelegate {

    //MARK: UIOutlets
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var GifView: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailPassField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInSignUpField: UIButton!
    
    //MARK: Declare Variables
    let loginGif = UIImage.gif(name: "welcomeGif")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         GifView.loadGif(name: "welcomeGif")
         GifAnimation()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    //MARK: GIF Work
    
    func GifAnimation(){
        
        GifView.animationImages = loginGif?.images
        // Set the duration of the UIImage
        GifView.animationDuration = loginGif!.duration
        // Set the repetitioncount
        GifView.animationRepeatCount = 0
        // Start the animation
        GifView.startAnimating()

        
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
        GifView.layer.add(animation, forKey: "animation")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        
        if flag {
            print("Animation finished")
            
        }
        
    }
    
    //MARK: UICustomisation
    
    func createTextField(){
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController{
    
}
