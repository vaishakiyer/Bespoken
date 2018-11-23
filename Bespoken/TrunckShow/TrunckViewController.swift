//
//  TrunckViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 23/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class TrunckViewController: UIViewController {

    @IBOutlet weak var trunckCollection: UICollectionView!
    var tap = UITapGestureRecognizer()
    
    var previewButtonPressed: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setup()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func setup(){
        
        self.navigationItem.title = "Trunck Shows"
        trunckCollection.delegate = self
        trunckCollection.dataSource = self
        trunckCollection.register(UINib(nibName: "TrunckViewCell", bundle: nil), forCellWithReuseIdentifier: "TrunckViewCell")
        trunckCollection.register(UINib(nibName: "PreviewImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PreviewImageCollectionViewCell")
    }
    
    func addGestureToView(){
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(){
        
        previewButtonPressed = false
        UIView.transition(with: trunckCollection, duration: 0.5, options: .transitionFlipFromRight, animations: {
            //Do the data reload here
            self.trunckCollection.performBatchUpdates({
                let indexSet = IndexSet(integersIn: 0...0)
                self.trunckCollection.reloadSections(indexSet)
            }, completion: nil)
            
        }, completion: nil)
        
        
        self.view.removeGestureRecognizer(tap)
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
extension TrunckViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if previewButtonPressed == true{
             return 1
        }else{
             return 5
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if previewButtonPressed == true{
            
            let cell = trunckCollection.dequeueReusableCell(withReuseIdentifier: "PreviewImageCollectionViewCell", for: indexPath) as? PreviewImageCollectionViewCell
            
            return cell!
            
        }else{
            
            let cell = trunckCollection.dequeueReusableCell(withReuseIdentifier: "TrunckViewCell", for: indexPath) as? TrunckViewCell
            cell!.delegate = self
            return cell!
        }
        
       
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "TinderSwipeControllerViewController") as? TinderSwipeControllerViewController
        nextVC?.controlFLow = FlowAnalysis(rawValue: "F2TrunckShow")
        self.navigationController?.pushViewController(nextVC!, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if previewButtonPressed == true{
            return CGSize(width: 280, height: 390)
        }else{
            return CGSize(width: 290, height: 50)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 0)
    }
    
    
}

extension TrunckViewController: TrunckViewDelegate{
    
    func buttonPreviewPressed(sender: TrunckViewCell) {
        previewButtonPressed = true
         addGestureToView()
        UIView.transition(with: trunckCollection, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            //Do the data reload here
            self.trunckCollection.performBatchUpdates({
                let indexSet = IndexSet(integersIn: 0...0)
                self.trunckCollection.reloadSections(indexSet)
            }, completion: nil)
            
        }, completion: nil)

    }
    
}
