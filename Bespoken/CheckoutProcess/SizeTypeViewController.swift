//
//  SizeTypeViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 01/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class SizeTypeViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var sizeCollection: UICollectionView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var measuredByView: UIView!
    
    
    var isSegmentChanged: Bool = false
    let titleArray = ["BUST","WAIST","HIP","UPPER ARM","SHOULDER"]
    var titleArray1 = ["NECKLINE","SLEEVE TYPE","LENGTH"]
    var imgArray = ["Group 727","Group 728","Group 729"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        
        sizeCollection.delegate = self
        sizeCollection.dataSource = self
        sizeCollection.register(UINib(nibName: "SizeSliderCell", bundle: nil), forCellWithReuseIdentifier: "SizeSliderCell")
        sizeCollection.register(UINib(nibName: "customTypeCell", bundle: nil), forCellWithReuseIdentifier: "customTypeCell")
        nextButton.roundCorners(corners: .allCorners, radius: 12)
        segmentControl.addTarget(self, action: #selector(segmentChanged(sender:)), for: .allEvents)
        measuredByView.isHidden = true
        
    }
    
    @objc func segmentChanged(sender: UISegmentedControl){
        
        
        switch  sender.selectedSegmentIndex {
        case 0:
            isSegmentChanged = false
            nextButton.setTitle("NEXT", for: .normal)
            measuredByView.isHidden = true
        default:
            
            measuredByView.isHidden = false
            isSegmentChanged = true
            nextButton.setTitle("ADD TO BAG", for: .normal)
        }
        
        sizeCollection.reloadData()
        
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
extension SizeTypeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch isSegmentChanged {
        case true:
            return titleArray1.count
        default:
             return titleArray.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch isSegmentChanged {
        case true:
            let cell = sizeCollection.dequeueReusableCell(withReuseIdentifier: "customTypeCell", for: indexPath) as?customTypeCell
            
            cell?.imgView.image = UIImage(named: imgArray[indexPath.item])
            cell?.titleLabel.text = titleArray1[indexPath.item]
            
            return cell!
        default:
            
            let cell = sizeCollection.dequeueReusableCell(withReuseIdentifier: "SizeSliderCell", for: indexPath) as? SizeSliderCell
            
            cell?.titleLabel.text = titleArray[indexPath.item]
            return cell!
        }
       
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch isSegmentChanged {
        case true:
            return CGSize(width: 157, height: 157)
        default:
              return CGSize(width: 372, height: 101)
        }
        
      
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch isSegmentChanged {
        case true:
            let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "customVideoController") as! customVideoController
            
            popoverContent.modalPresentationStyle = .overCurrentContext
            
            self.present(popoverContent, animated: true, completion: nil)

        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch isSegmentChanged {
        case true:
            
             return UIEdgeInsets(top: 10, left: sizeCollection.frame.width / 2 - 157, bottom: 10, right: sizeCollection.frame.width / 2 - 157)
        default:
             return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
       
    }
    
    
    
    
    
}


