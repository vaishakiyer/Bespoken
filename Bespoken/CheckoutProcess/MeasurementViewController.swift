//
//  ProductBagViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 27/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

struct MeasurementAnswer {
    
    var id : String?
    var answer : String?
}

var mySizeAnswer = MeasurementAnswer()

class MeasurementViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var measTypeCollection: UICollectionView!
    
    @IBOutlet weak var customiseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    var allAttributesCollected = [Attributes]()
    var shouldReload : Bool = true
    //MARK: - Viewcontroller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setup()
        
        // Do any additional setup after loading the view.
    }
    

    func setup(){
        
     measTypeCollection.delegate = self
     measTypeCollection.dataSource = self
     measTypeCollection.register(UINib(nibName: "sizeChartCell", bundle: nil), forCellWithReuseIdentifier: "sizeChartCell")
    customiseButton.roundCorners(corners: .allCorners, radius: 24)
    nextButton.roundCorners(corners: .allCorners, radius: 24)
        nextButton.addTarget(self, action: #selector(launchSizeController1), for: .touchUpInside)
        customiseButton.addTarget(self, action: #selector(launchSizeController), for: .touchUpInside)
        
    }
    
    @objc func launchSizeController1(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "SizeTypeViewController") as? SizeTypeViewController
        nextVC?.attributesNeeded = allAttributesCollected
        nextVC?.isNextPressed = true
        self.navigationController?.pushViewController(nextVC!, animated: true)
        
    }
    
    
    @objc func launchSizeController(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "SizeTypeViewController") as? SizeTypeViewController
        nextVC?.attributesNeeded = allAttributesCollected
        nextVC?.isNextPressed = false
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

extension MeasurementViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allAttributesCollected[0][section].choices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell =  measTypeCollection.dequeueReusableCell(withReuseIdentifier: "sizeChartCell", for: indexPath) as? sizeChartCell
        cell?.delegate = self
        
        cell?.sizeType.text = allAttributesCollected[0][indexPath.section].choices[indexPath.row].text
        cell?.sizeBtn1.setTitle(allAttributesCollected[0][indexPath.section].choices[indexPath.row].measurementOptions?.first, for: .normal)
        cell?.sizeBtn2.setTitle(allAttributesCollected[0][indexPath.section].choices[indexPath.row].measurementOptions?.last, for: .normal)
        
        
        if allAttributesCollected[0][indexPath.section].choices[indexPath.row].isValSelected == true{
            cell?.sizeBtn1.backgroundColor = UIColor.lightGray
            cell?.sizeBtn2.backgroundColor = UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1.0)
            mySizeAnswer.id = allAttributesCollected[0][indexPath.section].choices[indexPath.row].id
            mySizeAnswer.answer = allAttributesCollected[0][indexPath.section].choices[indexPath.row].measurementOptions?.first
            
        }else if allAttributesCollected[0][indexPath.section].choices[indexPath.row].isValSelected2 == true{
            cell?.sizeBtn2.backgroundColor = UIColor.lightGray
            cell?.sizeBtn1.backgroundColor = UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1.0)
            
            mySizeAnswer.id = allAttributesCollected[0][indexPath.section].choices[indexPath.row].id
            mySizeAnswer.answer = allAttributesCollected[0][indexPath.section].choices[indexPath.row].measurementOptions?.last
            
        }else{
             cell?.sizeBtn2.backgroundColor = UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1.0)
             cell?.sizeBtn1.backgroundColor = UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1.0)
        }
        
        return cell!
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 148, height: 127)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
    }
    
    
    
}

extension MeasurementViewController: ButtonTouchDelegate{
    
    func button1Pressed(sender: sizeChartCell) {
        
        shouldReload = false
        
        guard let indexPath = measTypeCollection.indexPath(for: sender) else {
            return
        }
        
        if allAttributesCollected[0][indexPath.section].choices[indexPath.row].isValSelected == true{
            
            allAttributesCollected[0][indexPath.section].choices[indexPath.row].isValSelected = false
        }else{
            
            for index in 0..<allAttributesCollected[0][indexPath.section].choices.count{
                allAttributesCollected[0][indexPath.section].choices[index].isValSelected = false
                allAttributesCollected[0][indexPath.section].choices[index].isValSelected2 = false
            }
            allAttributesCollected[0][indexPath.section].choices[indexPath.row].isValSelected = true
        }
        
       measTypeCollection.reloadData()
        
    }
    
    func button2Pressed(sender: sizeChartCell) {
        
         shouldReload = false
        
        guard let indexPath = measTypeCollection.indexPath(for: sender) else {
            return
        }
        
        if allAttributesCollected[0][indexPath.section].choices[indexPath.row].isValSelected2 == true{
            
            allAttributesCollected[0][indexPath.section].choices[indexPath.row].isValSelected2 = false
        }else{
            
            for index in 0..<allAttributesCollected[0][indexPath.section].choices.count{
                allAttributesCollected[0][indexPath.section].choices[index].isValSelected = false
                allAttributesCollected[0][indexPath.section].choices[index].isValSelected2 = false
            }
            allAttributesCollected[0][indexPath.section].choices[indexPath.row].isValSelected2 = true
        }
        
        measTypeCollection.reloadData()
        
        
    }
    
    
    
    
}
