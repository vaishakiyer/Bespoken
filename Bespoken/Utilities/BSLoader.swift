//
//  BSLoader.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 21/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import QuartzCore

public struct BSLoader {
    
    //MARK: - Change the variables values here for Custom uses
    public static var showFadeOutAnimation = false
    public static var pulseAnimation = true
    public static var activityColor: UIColor = UIColor.white
    public static var activityBackgroundImage : String = "Group 376"
    public static var activityBackgroundColor: UIColor = UIColor.gray
    public static var activityTextColor: UIColor = UIColor.white
    public static var activityTextFontName: UIFont = UIFont.systemFont(ofSize: 23)
    fileprivate static var activityWidth = (UIScreen.screenWidth / widthDivision) / 1.5
    fileprivate static var activityHeight = activityWidth / 0.66
    public static var widthDivision: CGFloat {
        get {
            guard UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad else {
                return 1.6
            }
            return 3.5
        }
    }
    public static var viewBackgroundDark: Bool = false
    public static var loadOverApplicationWindow: Bool = false
    
    
    //MARK: - Loading View
    public static var instance: LoadingResource?
    public static var backgroundView: UIView!
    fileprivate static var hidingInProgress = false
    
    
    public static func showLoading(_ text: String, disableUI: Bool,image: String) {
        BSLoader().startLoadingActivity(text, with: disableUI, with: image)
    }
    
    public static func showLoading() {
        BSLoader().startLoadingActivity("", with: false, with: "")
    }
    
    public static func hide(){
        DispatchQueue.main.async {
            instance?.hideActivity()
        }
    }
    
    //MARK: - Main Loading View creating here
    public class LoadingResource: UIView {
        fileprivate var textLabel: UILabel!
        fileprivate var backgroundImage = UIImageView()
        fileprivate var activityView: UIActivityIndicatorView!
        fileprivate var disableUIIntraction = false
        
        convenience init(text: String, disableUI: Bool,image: String){
            self.init(frame: CGRect(x: 0, y: 0, width: activityWidth, height: activityHeight))
            center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
//            backgroundColor = activityBackgroundColor
//            alpha = 1
//            layer.cornerRadius = frame.width / 2
            
            let yPosition = frame.height/2 - 20
            
            addActivityView(yPosition)
//            addImageToBackground(image: image)
//            addTextLabel(yPosition + activityView.frame.size.height, text: text)
            
            //Apply here Border & Shadow
//            checkActivityBackgroundColor()
            
            guard disableUI else {
                return
            }
            UIApplication.shared.beginIgnoringInteractionEvents()
            disableUIIntraction = true
        }
        
        private func checkActivityBackgroundColor(){
            guard activityBackgroundColor != .clear else {
                return
            }
            self.dropShadow()
            self.addBorder()
            addPulseAnimation()
        }
        
        //MARK: - Pulse Animation adding here
        fileprivate func addPulseAnimation(){
            guard pulseAnimation else {
                return
            }
            DispatchQueue.main.async {
                let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
                pulseAnimation.duration = 0.4
                pulseAnimation.fromValue = 0.8
                pulseAnimation.toValue = 1
                pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                pulseAnimation.autoreverses = true
                pulseAnimation.repeatCount = .greatestFiniteMagnitude
                self.layer.add(pulseAnimation, forKey: "animateOpacity")
            }
        }
        
        fileprivate func addActivityView(_ yPosition: CGFloat){
            activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            activityView.frame = CGRect(x: (frame.width/2) - 20, y: yPosition, width: 40, height: 40)
            activityView.color = activityColor
            activityView.startAnimating()
        }
        
        fileprivate func addImageToBackground(image: String){
            backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 20))
            backgroundImage.image = UIImage(named: image)
            
        }
        
        fileprivate func addTextLabel(_ yPosition: CGFloat, text: String){
            textLabel = UILabel(frame: CGRect(x: 5, y: yPosition + 50, width: activityWidth - 10, height: 40))
            textLabel.textColor = activityTextColor
            textLabel.font = activityTextFontName
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.minimumScaleFactor = 0.25
            textLabel.textAlignment = NSTextAlignment.center
            textLabel.numberOfLines = 0
            textLabel.text = text
        }
        
        fileprivate func showLoadingActivity() {
            addSubview(activityView)
//            addSubview(textLabel)
//            addSubview(backgroundImage)
            guard loadOverApplicationWindow else {
                topMostViewController!.view.addSubview(self)
                return
            }
            UIApplication.shared.windows.first?.addSubview(self)
        }
        
        fileprivate var fadeOutValue: CGFloat = 10.0
        
        fileprivate func hideActivity(){
          //  checkBackgoundWasClear()
            guard showFadeOutAnimation else {
                clearView()
                return
            }
            fadeOutAnimation()
        }
        
        fileprivate func fadeOutAnimation(){
            DispatchQueue.main.async {
                UIView.transition(with: self, duration: 0.3, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: self.fadeOutValue, y: self.fadeOutValue)
                    self.alpha = 0.2
                }, completion: { (value: Bool) in
                    self.clearView()
                })
            }
        }
        
        fileprivate func checkBackgoundWasClear(){
            guard activityBackgroundColor != .clear else {
                fadeOutValue = 2
                return
            }
            textLabel.alpha = 0
            activityView.alpha = 0
        }
        
        fileprivate func clearView(){
            activityView.stopAnimating()
            self.removeFromSuperview()
            instance = nil
            hidingInProgress = false
            
            if backgroundView != nil {
                UIView.animate(withDuration: 0.1, animations: {
                    backgroundView.backgroundColor = backgroundView.backgroundColor?.withAlphaComponent(0)
                }, completion: { _ in
                    backgroundView.removeFromSuperview()
                })
            }
            
            guard disableUIIntraction else {
                return
            }
            disableUIIntraction = false
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}

fileprivate extension UIView {
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addBorder(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
    }
}

fileprivate extension BSLoader{
    
    fileprivate func startLoadingActivity(_ text: String,with disableUI: Bool,with image: String){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            guard BSLoader.instance == nil else {
                print("\n ==============================* BSLoader *=====================================")
                print("Error: Loadering already active now, please stop that before creating a new one.")
                return
            }
            
            guard topMostViewController != nil else {
                print("\n ==============================* BSLoader *=====================================")
                print("Error: You don't have any views set. You may be calling in viewDidLoad or try inside main thread.")
                return
            }
            // Separate creation from showing
            BSLoader.instance = LoadingResource(text: text, disableUI: disableUI, image: image)
            DispatchQueue.main.async {
//                if BSLoader.viewBackgroundDark {
//                    if BSLoader.backgroundView == nil {
//                        BSLoader.backgroundView = UIView(frame: UIApplication.shared.keyWindow!.frame)
//                    }
//                    BSLoader.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
//                    topMostViewController?.view.addSubview(BSLoader.backgroundView)
//                    UIView.animate(withDuration: 0.2, animations: {BSLoader.backgroundView.backgroundColor = BSLoader.backgroundView.backgroundColor?.withAlphaComponent(0)})
//                }
                BSLoader.instance?.showLoadingActivity()
            }
        }
    }
}

fileprivate extension UIScreen {
    
    class var screenWidth: CGFloat {
        get {
            if UIInterfaceOrientation.portrait.isPortrait {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
    }
    
    class var screenHeight: CGFloat {
        get {
            if UIInterfaceOrientation.portrait.isPortrait {
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
        }
    }
}

fileprivate var topMostViewController: UIViewController? {
    var presentedVC = UIApplication.shared.keyWindow?.rootViewController
    while let controller = presentedVC?.presentedViewController {
        presentedVC = controller
    }
    return presentedVC
}

