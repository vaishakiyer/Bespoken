//
//  HomepageViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 19/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController,CAAnimationDelegate {

    @IBOutlet weak var GifImgView: UIImageView!
    @IBOutlet weak var optionCollection: UICollectionView!
    
    //MARK: Declare Variables
    
    let loginGif = UIImage.gif(name: "Homepage")
    var listArray = ["TRUNCK SHOW","COLLECTION","PERSONALISATION"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GifImgView.loadGif(name: "Homepage")
        setup()
        optionCollection.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    
    func setup(){
        
        optionCollection.register(UINib(nibName: "HomePageOptionCell", bundle: nil), forCellWithReuseIdentifier: "HomePageOptionCell")
        optionCollection.delegate = self
        optionCollection.dataSource = self
        GifAnimation()
        createNavbar()
    }
    
    
    //MARK: Animation
    
    func createNavbar(){
        self.navigationController?.navigationBar.isHidden = false
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomepageViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = optionCollection.dequeueReusableCell(withReuseIdentifier: "HomePageOptionCell", for: indexPath) as? HomePageOptionCell
        cell?.titleText.text = listArray[indexPath.item]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
       return  CGSize(width: 165, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 30, left: optionCollection.frame.width / 2 , bottom: 30, right: optionCollection.frame.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 2{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "PersonalisationController") as? PersonalisationController
            
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }else{
         
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "QuestionnaireController1") as? QuestionnaireController1
            self.navigationController?.pushViewController(nextVC!, animated: true)
            
        }
    }
    
    
}

class MyFlowLayout: UICollectionViewFlowLayout {
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes()
        attributes.alpha = 0
        attributes.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        return attributes
    }
}
