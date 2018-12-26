//
//  customVideoController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 06/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import AlamofireImage

class customVideoController: UIViewController {

    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var outerView: UIView!
    
    var myChoices = [Choice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myCollection.delegate = self
        myCollection.dataSource = self
        myCollection.register(UINib(nibName: "customVideoCell", bundle: nil), forCellWithReuseIdentifier: "customVideoCell")
        applyTouchGesture()
        // Do any additional setup after loading the view.
    }
    

    func applyTouchGesture(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRecognised))
        self.outerView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapRecognised(){
    
        self.dismiss(animated: true, completion: nil)
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

extension customVideoController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myChoices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  myCollection.dequeueReusableCell(withReuseIdentifier: "customVideoCell", for: indexPath) as? customVideoCell
        
        
        if let url = URL(string: myChoices[indexPath.item].image!){
             cell?.imgView.af_setImage(withURL: url)
        }
       
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: myCollection.frame.height / 2 - 45, left: 0, bottom: myCollection.frame.height / 2 - 45, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
}
