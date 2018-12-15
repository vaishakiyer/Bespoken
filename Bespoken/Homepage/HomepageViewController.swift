//
//  HomepageViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 19/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import Alamofire
import PulsingHalo

class HomepageViewController: UIViewController,CAAnimationDelegate {

    @IBOutlet weak var GifImgView: UIImageView!
    @IBOutlet weak var optionCollection: UICollectionView!
    @IBOutlet weak var videoBackgroudView: UIView!
    @IBOutlet weak var ballView: Homecenter1!
    @IBOutlet weak var viewTinderBackGround: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var ballButton: UIButton!
    
    //MARK: Declare Variables
    
    var listArray = ["EVENTS","COLLECTION","PERSONALISATION"]
    let videoPlay = VideoBackground()
    let halo = PulsingHaloLayer()
    var checkUser : User?
    
    var currentIndex = 0
    var currentLoadedCardsArray = [TinderCard]()
    var allCardsArray = [TinderCard]()
//    var valueArray = ["1","2","3","4","5","6","7","8","9","10"]
//    var imageArray = ["Mask Group 68","Mask Group 22","Mask Group 68","Group 732","Mask Group 68","Mask Group 68","Mask Group 22","Group 732","Mask Group 68","Mask Group 22"]
    var valueArray = ["1","2"]

    var imageArray = ["Mask Group 68","Mask Group 22"]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        optionCollection.isHidden = false
        ballButton.addTarget(self, action: #selector(startPulsating), for: .touchUpInside)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func startPulsating(){
        let halo = PulsingHaloLayer()
        halo.position = viewTinderBackGround.center
        view.layer.addSublayer(halo)
        halo.start()
        halo.radius = 240
        halo.backgroundColor = UIColor.black.cgColor

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playVideoInBackgroud()
        
        if currentLoadedCardsArray.count == 0 && checkUser != nil{
        let halo = PulsingHaloLayer()
        halo.position = viewTinderBackGround.center
        view.layer.addSublayer(halo)
        halo.start()
        halo.radius = 240
        halo.backgroundColor = UIColor.black.cgColor
        }
    }
    
    
    func setup(){
        
        //updateUI()
        ballButton.roundCorners(corners: .allCorners, radius: ballButton.frame.width / 2)
        optionCollection.register(UINib(nibName: "HomePageOptionCell", bundle: nil), forCellWithReuseIdentifier: "HomePageOptionCell")
        optionCollection.delegate = self
        optionCollection.dataSource = self
        createNavbar()
        getQuestions()
        fetchUser()
       // loadCardValues()
        
    }
    
    func updateUI(toHide: Bool){
        
        
        allCardsArray.removeAll()
        
        if let firstName = checkUser?.firstName{
         ballView.firstName.text = "HI " + firstName
        }
        
        if toHide == true{
             ballView.isHidden = false
             ballButton.isHidden = true
            
        }else{
            
            //ballView.isHidden = false
            //ballButton.isHidden = true
            
              ballView.isHidden = true
              loadCardValues()
        }
       
        
//        halo.position = viewTinderBackGround.center
//        view.layer.addSublayer(halo)
//        halo.radius = 240
//        halo.haloLayerNumber = 2
//        halo.repeatCount = .infinity
//        halo.start()
       
    
    }
    
    func createNavbar(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(openProfile))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Path 842"), style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    
    //MARK: Animation
    
    
    func playVideoInBackgroud(){
        
       try? videoPlay.play(view: videoBackgroudView, videoName: "videoplayback", videoType: "mp4", isMuted: true, darkness: 0.1, willLoopVideo: true, setAudioSessionAmbient: true)
        
    }
    
    
    //MARK: - Network Operation
    
    func fetchUser(){
        
        Alamofire.request(Router.getUser()).responseJSON { (response) in
            
            switch response.result{
                
            case .success(let JSON):
                
                print(JSON)
                
                guard let jsonArray = JSON as? [NSDictionary] else {return}
                
                let userDict = jsonArray.first
                
                BSUserDefaults.setLoggedInUserDict(userDict!)
                
                self.checkUser = BSUserDefaults.loggedInUser()
                if self.checkUser?.preferences?.count == 0{
                    self.updateUI(toHide: true)
                  
                }else{
                    self.updateUI(toHide: false)
                   
                }
                
             
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    
    func getQuestions(){
        
        Alamofire.request(Router.getQuestions()).responseJSON { (response) in
            
            switch response.result{
            case .success( _):
                
                let question = try? JSONDecoder().decode(Questionnaire.self, from: response.data!)
                myQuestions = question!
                
                break
                
            case .failure(let error):
                print(error)
                
            }
            
            
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
        
        
        if checkUser?.preferences?.count != 0{
            
            if indexPath.item == 2{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "PersonalisationController") as? PersonalisationController
                
                self.navigationController?.pushViewController(nextVC!, animated: true)
            }
            else if indexPath.item == 1{
                
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                let nextVC = storyBoard.instantiateViewController(withIdentifier: "QuestionnaireController1") as? QuestionnaireController1
//
//                nextVC?.completeAnsHandler = { () -> UIViewController in
//
//                    (self.navigationController?.popViewController(animated: true))!
//
//                }
//
//                self.navigationController?.pushViewController(nextVC!, animated: true)
                
                
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let nextVC = storyBoard.instantiateViewController(withIdentifier: "CollectionsViewController") as! UINavigationController
                
//                let nc = UINavigationController(rootViewController: nextVC!)
                
                self.present(nextVC, animated: true, completion: nil)
                
            }else if indexPath.item == 0{
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "TrunckViewController") as? TrunckViewController
                self.navigationController?.pushViewController(nextVC!, animated: true)
            }
            
            
            
        }else{
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "QuestionnaireController1") as? QuestionnaireController1
            
            self.navigationController?.pushViewController(nextVC!, animated: true)
            
            
        }
        
 
    }
    
    
}

extension HomepageViewController{
    
    func loadCardValues() {
        
        if valueArray.count > 0 {
            
           halo.backgroundColor = UIColor.clear.cgColor
            
            let capCount = (valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : valueArray.count
            
            for (i,value) in valueArray.enumerated() {
                let newCard = createTinderCard(at: i,value: value, imageAdded: imageArray[i])
                allCardsArray.append(newCard)
                if i < capCount {
                    currentLoadedCardsArray.append(newCard)
                }
            }
            
            for (i,_) in currentLoadedCardsArray.enumerated() {
                if i > 0 {
                    viewTinderBackGround.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i - 1])
                }else {
                    viewTinderBackGround.addSubview(currentLoadedCardsArray[i])
                }
            }
            animateCardAfterSwiping()
            perform(#selector(loadInitialDummyAnimation), with: nil, afterDelay: 1.0)
        }
        
    }
    @objc func openProfile(){
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.present(profileVC, animated: true, completion: nil)
    }
    
    @objc func loadInitialDummyAnimation() {
        
        let dummyCard = currentLoadedCardsArray.first;
        dummyCard?.shakeAnimationCard()
    }
    
    func createTinderCard(at index: Int , value :String , imageAdded: String) -> TinderCard {
        
        let card = TinderCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height), value: value, image: imageAdded)
        card.delegate = self
        return card
    }
    
    func removeObjectAndAddNewValues() {
        
        
        currentLoadedCardsArray.remove(at: 0)
        currentIndex = currentIndex + 1
        
        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
            var frame = card.frame
            frame.origin.y = CGFloat(MAX_BUFFER_SIZE * SEPERATOR_DISTANCE)
            card.frame = frame
            currentLoadedCardsArray.append(card)
            viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE - 2])
        }else{
            if currentLoadedCardsArray.count == 0{
                let halo = PulsingHaloLayer()
                halo.position = viewTinderBackGround.center
                view.layer.addSublayer(halo)
                halo.start()
                halo.radius = 240
                halo.backgroundColor = UIColor.black.cgColor
            }
        }
        
        print(currentIndex)
        animateCardAfterSwiping()
    }
    
    func animateCardAfterSwiping() {
        
        for (i,card) in currentLoadedCardsArray.enumerated() {
            UIView.animate(withDuration: 0.5, animations: {
                if i == 0 {
                    card.isUserInteractionEnabled = true
                }
                var frame = card.frame
                frame.origin.y = CGFloat(i * SEPERATOR_DISTANCE)
                card.frame = frame
            })
        }
    }
    
    
    
    
}

extension HomepageViewController : TinderCardDelegate{
    func cardTapped(card: TinderCard) {
        print("Card Tapped")
    }
    
    
    
    // action called when the card goes to the left.
    func cardGoesLeft(card: TinderCard) {
        removeObjectAndAddNewValues()
    }
    // action called when the card goes to the right.
    func cardGoesRight(card: TinderCard) {
        removeObjectAndAddNewValues()
    }
    func currentCardStatus(card: TinderCard, distance: CGFloat) {
        
        
        
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
