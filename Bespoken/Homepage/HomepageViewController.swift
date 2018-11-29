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

class HomepageViewController: UIViewController,CAAnimationDelegate {

    @IBOutlet weak var GifImgView: UIImageView!
    @IBOutlet weak var optionCollection: UICollectionView!
    @IBOutlet weak var videoBackgroudView: UIView!
    @IBOutlet weak var ballView: Homecenter1!
    
    //MARK: Declare Variables
    
    var listArray = ["TRUNCK SHOW","COLLECTION","PERSONALISATION"]
    let videoPlay = VideoBackground()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        optionCollection.isHidden = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playVideoInBackgroud()
       
    }
    
    
    func setup(){
        
        updateUI()
        optionCollection.register(UINib(nibName: "HomePageOptionCell", bundle: nil), forCellWithReuseIdentifier: "HomePageOptionCell")
        optionCollection.delegate = self
        optionCollection.dataSource = self
        createNavbar()
        getQuestions()
        fetchUser()
        
    }
    
    func updateUI(){
        
        if let firstName = BSUserDefaults.loggedName(){
         ballView.firstName.text = "HI " + firstName
        }
        
    }
    
    func createNavbar(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: nil)
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
        
        if indexPath.item == 2{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "PersonalisationController") as? PersonalisationController
            
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }else if indexPath.item == 0{
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "TrunckViewController") as? TrunckViewController
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
        else{
         
            
            
//            let view1 = Example2View()
//            let malert = Malert(customView: view1)
//
//            let action = MalertAction(title: "OK")
//            action.tintColor = UIColor(red:0.15, green:0.64, blue:0.85, alpha:1.0)
//
//
//            malert.addAction(action)
//
//            present(malert, animated: true)

            
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
