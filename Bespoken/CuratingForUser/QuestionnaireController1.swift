//
//  QuestionnaireController1.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 19/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class QuestionnaireController1: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    
    @IBOutlet weak var optionCollection: UICollectionView!
    
    
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
            
//            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
//                cell.transform = CGAffineTransformMakeTranslation(0, 0);
//            }, completion: nil)
            
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
            
        }else if nextCountPress == 1{
            
            titleArray = ["WEDDING PARTY","BRIDAL TROUSSEAU","COCKTAIL","SEASONAL","RESORT","DAY"]
            title1.text = "MY OCCASION DRESSING"
            title2.text = "OPTION ARE"
            
        }else if nextCountPress == 2{
            
            titleArray = ["ANGULAR & SLIM","LEAN STRUCTURE","IDEAL HOURGLASS","FULL & CURVY","TALL & PROPRTIONATE","STRONG BONE STRUCTURE"]
            title1.text = "MY BODY"
            title2.text = "TYPE IS"
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
        optionCollection.reloadData()
        
        
        
        
    }
    
    @objc func nextPressed(){
        
        nextCountPress += 1
        
        if nextCountPress != 0{
            createNavBar(leftButton: "PREVIOUS")
        }else{
            nextCountPress = 0
            createNavBar(leftButton: "HOMEPAGE")
        }
        
        if nextCountPress == 1{
            titleArray = ["WEDDING PARTY","BRIDAL TROUSSEAU","COCKTAIL","SEASONAL","RESORT","DAY"]
            title1.text = "MY OCCASION DRESSING"
            title2.text = "OPTION ARE"
        }else if nextCountPress == 2{
            titleArray = ["ANGULAR & SLIM","LEAN STRUCTURE","IDEAL HOURGLASS","FULL & CURVY","TALL & PROPRTIONATE","STRONG BONE STRUCTURE"]
            title1.text = "MY BODY"
            title2.text = "TYPE IS"
        }else{
            
            nextCountPress -= 1
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "TinderSwipeControllerViewController") as? TinderSwipeControllerViewController
            nextVC?.controlFLow = FlowAnalysis(rawValue: "F1Brand")
            self.navigationController?.pushViewController(nextVC!, animated: true)
            
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
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = optionCollection.dequeueReusableCell(withReuseIdentifier: "CurationViewCell", for: indexPath) as? CurationViewCell
        cell?.titleText.text = titleArray[indexPath.item]
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }
    
    
}
