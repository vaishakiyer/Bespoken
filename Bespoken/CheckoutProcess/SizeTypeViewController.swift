//
//  SizeTypeViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 01/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import AlamofireImage

class SizeTypeViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var sizeCollection: UICollectionView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var measuredByView: UIView!
    
    var attributesNeeded = [Attributes]()
    
    var isSegmentChanged: Bool = false
    var isNextPressed : Bool = false
    var myOption = [MeasurementAnswer]()
   
    
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
        nextButton.addTarget(self, action: #selector(toBagController), for: .touchUpInside)
        segmentControl.addTarget(self, action: #selector(segmentChanged(sender:)), for: .allEvents)
        
        self.navigationItem.title = "MEASUREMENT"
        
        switch isNextPressed {
        case false:
            isSegmentChanged = false
            segmentControl.isHidden = false
            nextButton.isHidden = true
            measuredByView.isHidden = false
        case true:
            
            measuredByView.isHidden = true
            isSegmentChanged = true
            segmentControl.isHidden = true
            nextButton.isHidden = false
            nextButton.setTitle("ADD TO BAG", for: .normal)
            
        }
        
         sizeCollection.reloadData()
        
        for val in attributesNeeded[1]{
            var tempObj = MeasurementAnswer()
            tempObj.id = val.id
            myOption.append(tempObj)
        }
        
        
    }
    
    @objc func segmentChanged(sender: UISegmentedControl){
        
        
        switch  sender.selectedSegmentIndex {
        case 0:
            isSegmentChanged = false
            nextButton.isHidden = true
            measuredByView.isHidden = false
            
        default:
            
            measuredByView.isHidden = true
            isSegmentChanged = true
            nextButton.isHidden = false
            nextButton.setTitle("ADD TO BAG", for: .normal)
        }
        
        sizeCollection.reloadData()
        
    }
    
    @objc func toBagController(){
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let nextVC = storyBoard.instantiateViewController(withIdentifier: "BagViewController") as? BagViewController
    self.navigationController?.pushViewController(nextVC!, animated: true)

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
            return attributesNeeded[2].count
        default:
             return attributesNeeded[1].count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch isSegmentChanged {
        case true:
            let cell = sizeCollection.dequeueReusableCell(withReuseIdentifier: "customTypeCell", for: indexPath) as? customTypeCell
            
            
            if let url = URL(string: attributesNeeded[2][indexPath.item].image!){
                  cell?.imgView.af_setImage(withURL: url)
            }
           
            cell?.titleLabel.text = attributesNeeded[2][indexPath.item].text
            
            return cell!
        default:
            
            let cell = sizeCollection.dequeueReusableCell(withReuseIdentifier: "SizeSliderCell", for: indexPath) as? SizeSliderCell
            
            cell?.titleLabel.text = attributesNeeded[1][indexPath.item].text! + " (" + attributesNeeded[1][indexPath.item].units!.lowercased() + ")"
            cell?.mySlider.minimumValue = (attributesNeeded[1][indexPath.item].range?.first)!
            cell?.mySlider.maximumValue = (attributesNeeded[1][indexPath.item].range?.last)!
            
            cell?.valueHandler = { (value) -> Void in
                self.attributesNeeded[1][indexPath.item].valueChosen = value
                self.myOption[indexPath.item].answer = value
            }
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
            popoverContent.myChoices = attributesNeeded[2][indexPath.item].choices
                
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


