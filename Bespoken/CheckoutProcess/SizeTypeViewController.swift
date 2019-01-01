//
//  SizeTypeViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 01/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class SizeTypeViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var sizeCollection: UICollectionView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var measuredByView: UIView!
    @IBOutlet weak var stylistSwitch: UISwitch!
    
    
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
        
        
        stylistSwitch.isOn = false
        stylistSwitch.setOn(false, animated: true)
        sizeCollection.delegate = self
        sizeCollection.dataSource = self
        sizeCollection.register(UINib(nibName: "SizeSliderCell", bundle: nil), forCellWithReuseIdentifier: "SizeSliderCell")
        sizeCollection.register(UINib(nibName: "customTypeCell", bundle: nil), forCellWithReuseIdentifier: "customTypeCell")
        nextButton.roundCorners(corners: .allCorners, radius: 12)
        nextButton.addTarget(self, action: #selector(toBagController), for: .touchUpInside)
        segmentControl.addTarget(self, action: #selector(segmentChanged(sender:)), for: .allEvents)
        self.navigationItem.leftBarButtonItem =   UIBarButtonItem(image: UIImage(named: "BackMotif_white"), style: .done, target: self, action: #selector(dismissController))
        self.navigationController?.navigationBar.tintColor = .black
        let motifView = UIImageView(image: UIImage(named: "Motif"))
        motifView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = motifView
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
    @objc func dismissController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        
        switch sender.isOn {
        case true:
            
            stylistSwitch.setOn(true, animated: true)
            let alertControl = UIAlertController(title: "Please enter the Stylist Code", message: "", preferredStyle: .alert)
            alertControl.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter Stylist Code"
                textField.keyboardType = .numberPad
            })

            let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
                let firstTextField = alertControl.textFields![0] as UITextField
                print(firstTextField)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (weak) in
                self.stylistSwitch.setOn(false, animated: true)
                self.stylistSwitch.isOn = false
            }
            alertControl.addAction(saveAction)
            alertControl.addAction(cancelAction)
            
            self.present(alertControl, animated: true, completion: nil)
            
        case false:
            
            stylistSwitch.setOn(false, animated: true)
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
    
             postTheAttributes()

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
            popoverContent.optionHandler = { (optionIndex) -> Void in
                
                var option = MeasurementAnswer()
                option.id = self.attributesNeeded[2][indexPath.item].choices[optionIndex].id
                option.answer = self.attributesNeeded[2][indexPath.item].choices[optionIndex].text
                self.myOption.append(option)
                for (index,vals) in self.myOption.enumerated(){
                    if vals.id == option.id{
                        self.myOption[index].answer = option.answer
                    }
                    
                }
              
              //  self.myOption = self.myOption.unique(by: {($0.answer != nil)})
                
            }
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


//MARK: - Network Operation

extension SizeTypeViewController{
    
    func postTheAttributes(){
        
        BSLoader.showLoading("", disableUI: true, image: "Group 376")
        
        var tempDict = [NSDictionary]()
        
        
        myOption.append(mySizeAnswer)
        
        tempDict.removeAll()
        
        for item in myOption{
            
            if item.answer != nil{
            
            if let intVal = Int(item.answer!){
                
                if intVal > 0{
                    let obj = NSMutableDictionary()
                    obj["attribute"] = item.id
                    obj["answer"] = item.answer
                    tempDict.append(obj)
                }
                
            }else{
                
                let obj = NSMutableDictionary()
                obj["attribute"] = item.id
                obj["answer"] = item.answer
                tempDict.append(obj)
                
              }
            }
        }
        
        print(tempDict)
        
        Alamofire.request(Router.postAttributes(prodId: currentProductId!, preferences: tempDict)).responseJSON{ (response) in
            
            BSLoader.hide()
            
            switch response.result{
                
            case .success(let json):
                print(json)
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "BagViewController") as? BagViewController
                self.navigationController?.pushViewController(nextVC!, animated: true)
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
    
        }
        
        
    }
    
    
}

