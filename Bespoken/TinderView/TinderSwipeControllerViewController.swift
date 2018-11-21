//
//  TinderSwipeControllerViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 20/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

let  MAX_BUFFER_SIZE = 3;
let  SEPERATOR_DISTANCE = 8;
let  TOPYAXIS = 75;


class TinderSwipeControllerViewController: UIViewController {

    @IBOutlet weak var viewTinderBackGround: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var currentIndex = 0
    var currentLoadedCardsArray = [TinderCard]()
    var allCardsArray = [TinderCard]()
    var valueArray = ["1","2","3","4","5","6","7","8","9","10"]
    var imageArray = ["Mask Group 68","Mask Group 22","Mask Group 68","Group 732","Mask Group 68","Mask Group 68","Mask Group 22","Group 732","Mask Group 68","Mask Group 22"]
    var controlFLow : FlowAnalysis?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialDataSetup()
        footerLabel.isHidden = true
        nextButton.roundCorners(corners: .allCorners, radius: 16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
       
        
    }
    
    
    
    @objc func nextPressed(){
        
        switch controlFLow {
            
        case .Flow1_SelectBrand?:
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "TinderSwipeControllerViewController") as? TinderSwipeControllerViewController
            nextVC?.controlFLow = FlowAnalysis(rawValue: "F1Garment")
           DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.navigationController?.pushViewController(nextVC!, animated: true)
           }
           
            
            
        case .Flow1_SelectGarment?:
            
            BSLoader.showLoading("CURATING YOUR STYLE STATEMENT NOW", disableUI: true, image: "Group 376")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                BSLoader.hide()
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                  self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
            }
            
            
           break
            
        case .none:
            print("case not identified")
        }
    }
    
    func initialDataSetup(){
        
        BSLoader.activityTextFontName = UIFont.boldSystemFont(ofSize: 15)
        BSLoader.activityTextColor = .white
        BSLoader.activityBackgroundColor = .darkGray
        nextButton.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        loadCardValues()
    
        switch controlFLow! {
        case .Flow1_SelectBrand:
            headerLabel.text = "Let us know you preference for brands"
            createNavBar(title: "BRANDS")
           
        case .Flow1_SelectGarment:
            createNavBar(title: "GARMENTS")
             headerLabel.text = "Let us know you preference for garments"
            
        }
        
    }
    
    
    func createNavBar(title: String){
        self.navigationItem.title = title
    }
    
    func loadCardValues() {
        
        if valueArray.count > 0 {
            
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

extension TinderSwipeControllerViewController : TinderCardDelegate{
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
