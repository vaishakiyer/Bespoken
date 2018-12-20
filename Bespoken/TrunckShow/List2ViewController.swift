//
//  List2ViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 18/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class List2ViewController: UIViewController {

    @IBOutlet weak var trunckCollection: UICollectionView!
    var mySections = [String]()
    var myEvents = TrunckShow()
    var myGroupedEvents = [TrunckShow]()
    let segment: UISegmentedControl = UISegmentedControl(items: ["First", "Second"])
    var presentHandler: (() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        
        
        segment.sizeToFit()
        segment.tintColor = UIColor(red:0, green:0, blue:0, alpha:1.00)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        segment.selectedSegmentIndex = 1;
        segment.addTarget(self, action: #selector(segementChanged(sender:)), for: .allEvents)
        //segment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "ProximaNova-Light", size: 15)!], for: .normal)
        self.navigationItem.titleView = segment
        getEvents()
        trunckCollection.delegate = self
        trunckCollection.dataSource = self
        trunckCollection.register(UINib(nibName: "List2CollectionCell", bundle: nil), forCellWithReuseIdentifier: "List2CollectionCell")
        trunckCollection.register(UINib(nibName: "eventsHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "eventsHeader")
        
    }
   
    @objc func segementChanged(sender: UISegmentedControl){
        
        switch sender.selectedSegmentIndex {
        case 0:
            
        self.presentHandler()
        self.dismiss(animated: true, completion: nil)
            
        default:
            
           break
            
        }
        
        
        
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

extension List2ViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mySections.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return myGroupedEvents[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
       
            return CGSize(width: self.view.frame.width, height: 50)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
   
            
            let header = trunckCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "eventsHeader", for: indexPath) as? eventsHeader
            header?.titleLabel.text = mySections[indexPath.row]
            
            return header!
        
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = trunckCollection.dequeueReusableCell(withReuseIdentifier: "List2CollectionCell", for: indexPath) as? List2CollectionCell
        
        if let url = URL(string: myGroupedEvents[indexPath.section][indexPath.item].bannerImage!){
            cell!.backImage.af_setImage(withURL: url)
        }
        
        cell?.titleLabel.text = myGroupedEvents[indexPath.section][indexPath.item].title
       
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
            return CGSize(width: self.view.frame.width, height: 70)
    
    }
    
    
}

extension List2ViewController{
    
    func getEvents(){
        
        
        Alamofire.request(Router.getEvents(lat: myLocation.latitude!, long: myLocation.longitude!)).responseJSON { (response) in
            
            
            switch response.result{
                
            case .success(let JSON):
                
                print(JSON)
                let events = try? JSONDecoder().decode(TrunckShow.self, from: response.data!)
                
                if let val = events{
                    self.myEvents = val
                }
                let x = self.myEvents.unique(by: {$0.category})
                
                for items in x{
                    self.mySections.append(items.category!)
                }
                
                self.myGroupedEvents = self.myEvents.group(by: {$0.category})
                
                self.trunckCollection.reloadData()
                
            case .failure(let error):
                print(error)
                
                
            }
            
            
        }
        
    }
    
    
}
