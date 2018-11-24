//
//  LoginViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 18/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

let VerifyPasscode = "987654"

import UIKit
import TOPasscodeViewController

class LoginViewController: UIViewController,CAAnimationDelegate {

    //MARK: UIOutlets
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var GifView: UIImageView!
    @IBOutlet weak var bottomSignIn: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    
    
    @IBOutlet weak var usernameField: DesignableUITextField!
   
    @IBOutlet weak var emailPassField: DesignableUITextField!
    
    @IBOutlet weak var passwordField: DesignableUITextField!
    
    @IBOutlet weak var signInSignUpField: UIButton!
    
    //MARK: Declare Variables
    let loginGif = UIImage.gif(name: "welcomeGif")
    var isFlipped : Bool = false
    let nextVC = TOPasscodeSettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         GifView.loadGif(name: "welcomeGif")
         setup()
         self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         createNavBar()
    }
    
    //MARK: Intialisation
    
    func setup(){
        
        nextVC.delegate = self
        nextVC.requireCurrentPasscode = true
        nextVC.setPasscodeType(.sixDigits, animated: true)
        nextVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissTOPasscodeController))
        nextVC.style = .dark
        
        
        loginView.isHidden = true
        bottomLabel.isHidden = true
        bottomSignIn.isHidden = true
        
        usernameField.delegate = self
        emailPassField.delegate = self
        passwordField.delegate = self
        
        signInSignUpField.addTarget(self, action: #selector(signInOrSignUpPressed), for: .touchUpInside)
        
        GifAnimation()
       
    }
    
    @objc func dismissTOPasscodeController(){
        dismiss(animated: true, completion: nil)
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
            
            UIView.transition(with: loginView, duration: 1, options: .transitionFlipFromTop, animations: {
                self.loginView.isHidden = false
                self.bottomLabel.isHidden = false
                self.bottomSignIn.isHidden = false
            }) { (weak) in
                self.createTextField()
                self.customiseSignButton()
            }
            
        }
        
    }
    
    //MARK: UICustomisation
    
    
    func createNavBar(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func createTextField(){
        Helper.addLineToView(view: usernameField, position: .LINE_POSITION_BOTTOM, color: .white, width: 0.5)
        Helper.addLineToView(view: emailPassField, position: .LINE_POSITION_BOTTOM, color: .white, width: 0.5)
        Helper.addLineToView(view: passwordField, position: .LINE_POSITION_BOTTOM, color: .white, width: 0.5)
        
        
        usernameField.addImageAndPlaceHolder(img: "Group377", placeHolder: "USERNAME")
        emailPassField.addImageAndPlaceHolder(img: "Group381", placeHolder: "EMAIL ID")
        passwordField.addImageAndPlaceHolder(img: "Group382", placeHolder: "PASSWORD")
    }
    
    func customiseSignButton(){
        signInSignUpField.roundCorners(corners: .allCorners, radius: 24)
    }
    
    
    //MARK: Touch Responders
    
    @IBAction func signInPressed(_ sender: Any) {
        
       // self.loginView.transform = CGAffineTransform(scaleX: -1, y: 1)
        isFlipped = !isFlipped
        createChangedOnFlip()
      
    }
    
    func createChangedOnFlip(){
        
        switch isFlipped {
        case true:
            
           
            bottomLabel.text = "Don't have an account?"
            bottomSignIn.setTitle("Sign Up!", for: .normal)
            signInSignUpField.setTitle("SIGN IN", for: .normal)
            passwordField.isHidden = true
            emailPassField.addImageAndPlaceHolder(img: "Group382", placeHolder: "PASSWORD")
            
            break
            
        default:
            
           
            bottomLabel.text = "Already got an account?"
            bottomSignIn.setTitle("Sign In!", for: .normal)
            signInSignUpField.setTitle("SIGN UP", for: .normal)
            passwordField.isHidden = false
            emailPassField.addImageAndPlaceHolder(img: "Group381", placeHolder: "EMAIL ID")
            
        }
        
    }
    
    
    
    
    
    @objc func signInOrSignUpPressed(){
    
        let nc = UINavigationController.init(rootViewController: nextVC)
        self.present(nc, animated: true, completion: nil)
    
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

extension LoginViewController: UITextFieldDelegate{
    
}

extension LoginViewController: TOPasscodeSettingsViewControllerDelegate{
    
    func passcodeSettingsViewController(_ passcodeSettingsViewController: TOPasscodeSettingsViewController, didAttemptCurrentPasscode passcode: String) -> Bool {
        
        if passcode != VerifyPasscode{
              return false
            
        }else{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC1 = storyBoard.instantiateViewController(withIdentifier: "HomepageViewController") as? HomepageViewController
            passcodeSettingsViewController.navigationController?.pushViewController(nextVC1!, animated: true)
            return true
            
        }
        
      
        
    }
    
    
}
