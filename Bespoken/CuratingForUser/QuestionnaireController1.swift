//
//  QuestionnaireController1.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 19/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

var myQuestions = Questionnaire()

class QuestionnaireController1: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    
    @IBOutlet weak var optionCollection: UICollectionView!
    
    var completeAnsHandler : ((_ value: String) -> UIViewController)!
    var answered = [PostAnswers]()
    
    //MARK: Declare Variables
    
    var nextCountPress : Int = 0
    var titleArray = [String]()
    
    //MARK: ViewControl Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        animateTable()
    }
    
    
    //MARK: Intialisation
    
    func setup(){
        optionCollection.register(UINib(nibName: "CurationViewCell", bundle: nil), forCellWithReuseIdentifier: "CurationViewCell")
        optionCollection.delegate = self
        optionCollection.dataSource = self
        
        for items in myQuestions{
           
            if items.tab == 0{
            let ans = PostAnswers(question: items.id!)
            answered.append(ans)
            }
        }
       
        
        createNavBar(leftButton: "HOMEPAGE")
        titleArray = ["SENSUOS","ELEGANT","SOPHISTICATED","CREATIVE & UNIQUE","COMFORTABLE","BOLD"]
        
    }
    
    func createNavBar(leftButton: String){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: leftButton, style: .plain, target: self, action: #selector(backPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "NEXT", style: .plain, target: self, action: #selector(nextPressed))
    }
    
    
    func animateTable(){
        
        optionCollection.reloadData()
        
        let cells = optionCollection.visibleCells
        let collectionHeight: CGFloat = optionCollection.bounds.size.height
        
        for i in cells {
            let cell: UICollectionViewCell = i as UICollectionViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: collectionHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UICollectionViewCell = a as UICollectionViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), options: .curveEaseOut, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            
            
            index += 1
        }
        
        
    }
    
    
    //MARK: Touch Responders
    
    @objc func backPressed(){
        
    
         nextCountPress -= 1
        
        if nextCountPress != 0{
            createNavBar(leftButton: "PREVIOUS")
        }else{
            nextCountPress = 0
            createNavBar(leftButton: "HOMEPAGE")
        }
        
        if nextCountPress == 0{
            
            titleArray = ["SENSUOS","ELEGANT","SOPHISTICATED","CREATIVE & UNIQUE","COMFORTABLE","BOLD"]
            title1.text = "THE STYLE"
            title2.text = "I LIKE MOST"
             optionCollection.reloadData()
            
        }else if nextCountPress == 1{
            
            titleArray = ["WEDDING PARTY","BRIDAL TROUSSEAU","COCKTAIL","SEASONAL","RESORT","DAY"]
            title1.text = "MY OCCASION DRESSING"
            title2.text = "OPTION ARE"
             optionCollection.reloadData()
            
        }else if nextCountPress == 2{
            
            titleArray = ["ANGULAR & SLIM","LEAN STRUCTURE","IDEAL HOURGLASS","FULL & CURVY","TALL & PROPRTIONATE","STRONG BONE STRUCTURE"]
            title1.text = "MY BODY"
            title2.text = "TYPE IS"
             optionCollection.reloadData()
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func nextPressed(){
        
       
        
        if nextCountPress < myQuestions.count - 1 {
            if myQuestions[nextCountPress + 1].tab == 0{
            nextCountPress += 1
            }else{
                
                updateUserPreferences()
                
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                let nextVC = storyBoard.instantiateViewController(withIdentifier: "TinderSwipeControllerViewController") as? TinderSwipeControllerViewController
//                nextVC?.controlFLow = FlowAnalysis(rawValue: "F1Brand")
//                self.navigationController?.pushViewController(nextVC!, animated: true)
                
            }
        }else{
            
            updateUserPreferences()
        }
        
        
        if nextCountPress != 0{
            createNavBar(leftButton: "PREVIOUS")
        }else{
            nextCountPress = 0
            createNavBar(leftButton: "HOMEPAGE")
        }
        
        
        if nextCountPress == 1{
           
            title1.text = "MY OCCASION DRESSING"
            title2.text = "OPTION ARE"
        }else if nextCountPress == 2{
            
            title1.text = "MY BODY"
            title2.text = "TYPE IS"
        }
        
        
        optionCollection.reloadData()
        
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

extension QuestionnaireController1: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if myQuestions.count != 0{
            
             return myQuestions[nextCountPress].options?.count ?? 0
            
        }else{
            
            return 0
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = optionCollection.dequeueReusableCell(withReuseIdentifier: "CurationViewCell", for: indexPath) as? CurationViewCell
        
        if myQuestions[nextCountPress].options?[indexPath.row].archived == true{
            
           cell?.innerView.backgroundColor = UIColor.groupTableViewBackground
        }else{
           
            cell?.innerView.backgroundColor = UIColor.white
        }
        if let url = URL(string: (myQuestions[nextCountPress].options?[indexPath.row].image)!){
             cell?.imageView.af_setImage(withURL: url)
        }
       
        cell?.titleText.text = myQuestions[nextCountPress].options?[indexPath.row].text
        return cell!
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if myQuestions[nextCountPress].options?[indexPath.row].archived == true{
            myQuestions[nextCountPress].options?[indexPath.row].archived = false
            
                for (index,val) in answered[nextCountPress].answers.enumerated(){
                    
                    if val == myQuestions[nextCountPress].options?[indexPath.row].id{
                        
                        answered[nextCountPress].answers.remove(at: index)
                    }
                }
            
            
         }else{
            answered[nextCountPress].answers.append((myQuestions[nextCountPress].options?[indexPath.row].id)!)
            myQuestions[nextCountPress].options?[indexPath.row].archived = true
        }
        
    
        
         optionCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        myQuestions[nextCountPress].options?[indexPath.row].archived = false
        optionCollection.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }
    
    
}

//MARK: - Network Operation

extension QuestionnaireController1{
    
    func updateUserPreferences(){
        
        BSLoader.showLoading("", disableUI: true, image: "Group 376")
        
       var mainDictArr = [NSDictionary]()
        
        for values in answered{
            
            let tempDict = NSMutableDictionary()
            tempDict["question"] = values.question
            tempDict["answer"] = values.answers
            mainDictArr.append(tempDict)
        }
        
        Alamofire.request(Router.updateUser(answers: mainDictArr)).responseJSON(completionHandler: { (response) in
            
            BSLoader.hide()
            
            switch response.result{
            case.success(let JSON):
                print(JSON)
                
                guard let status = (JSON as? NSDictionary)?.value(forKeyPath: "data.result") as? String else {return}
                
                if status == "success"{
                    
                    self.completeAnsHandler("F1Brand")
                
                }else{
                    self.showAlert(message: "Could not update your preferences")
                }
               
                
                
            case .failure(let error):
                print(error)
            }
            
        })
        
        
        
    }
}
