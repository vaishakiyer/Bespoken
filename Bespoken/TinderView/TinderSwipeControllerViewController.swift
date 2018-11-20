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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.roundCorners(corners: .allCorners, radius: 16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
        loadCardValues()
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
