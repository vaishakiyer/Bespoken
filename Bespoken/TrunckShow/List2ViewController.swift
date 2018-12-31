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
import QRCodeReader

class List2ViewController: UIViewController {

    @IBOutlet weak var trunckCollection: UICollectionView!
    var mySections = [String]()
    var myEvents = TrunckShow()
    var myGroupedEvents = [TrunckShow]()
    
    var allProducts : [Product] = []
    let segment: UISegmentedControl = UISegmentedControl(items: ["First", "Second"])
    var presentHandler: (() -> Void)!
    var playHandler : ((_ prodId: String) -> Void)!
    
    
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        
        segment.removeBorders()
        segment.sizeToFit()
        segment.tintColor = UIColor(red:0, green:0, blue:0, alpha:1.00)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        segment.selectedSegmentIndex = 1
        segment.setTitle("R S V P", forSegmentAt: 0)
        segment.setTitle("E V E N T S", forSegmentAt: 1)
        segment.addTarget(self, action: #selector(segementChanged(sender:)), for: .allEvents)
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
       
            return CGSize(width: self.view.frame.width, height: 0)
        
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
        
        cell?.delegate = self
        cell?.titleLabel.text = myGroupedEvents[indexPath.section][indexPath.item].title
       
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
            return CGSize(width: 320, height: 180)
    
    }
    
    
}

//MARK: - TruckDelegates

extension List2ViewController: TrunckViewDelegate,QRCodeReaderViewControllerDelegate{
    
    func buttonPreviewPressed(sender: List2CollectionCell) {
        
        
        guard let tappedIndex  = trunckCollection.indexPath(for: sender) else {return}
        

       let prodId = myGroupedEvents[tappedIndex.section][tappedIndex.row].id
        self.playHandler(prodId!)
    }
    
    func scanButtonPressed(sender: List2CollectionCell){
        
        readerVC.delegate = self
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
        
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print(result.value)
        reader.stopScanning()
        
        let sentence = result.value
        let words = sentence.byWords
        
        if words.first == "product"{
            getProduct(prodId: (words.last?.description)!)
        }else if words.first == "event"{
            getEvent(eventId: (words.last?.description)!)
        }
        
        // dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        print("Action Cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    
}


//MARK: - Network Operation

extension List2ViewController{
    
    func getProduct(prodId: String){
        
        Alamofire.request(Router.getProductBy(id: prodId)).responseJSON { (response) in
            
            switch response.result{
                
            case .success(let JSON):
                
                print(JSON)
                
                guard let jsonArray = JSON as? [NSDictionary] else {return}
                
                for item in jsonArray{
                    
                    let product = Product(json: item as! JSON)
                    self.allProducts.append(product)
                    
                }
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "ProductCheckoutController") as? ProductCheckoutController
                nextVC?.theProduct = self.allProducts.first!
                let nc = UINavigationController(rootViewController: nextVC!)
                self.readerVC.present(nc, animated: true, completion: nil)
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    func getEvent(eventId: String){
        
        Alamofire.request(Router.getEventBy(id: eventId)).responseJSON { (response) in
            
            switch response.result{
            case .success(let JSON):
                
                print(JSON)
                let events = try? JSONDecoder().decode(TrunckShow.self, from: response.data!)
                
                if (events?[0].seatsAvailable!)! < 10{
                    self.showAlert(message: "HURRY UP!.\n Last 3 seats are available")
                }else{
                    
                    let message = "\n Please proceed to purchase the ticket \n\n" + "Available Seats: " + (events?[0].seatsAvailable!.description)!
                    let titleLabel = (events?[0].title!)! + "\n" + (events?[0].location!)!
                    let alertController = UIAlertController(title: titleLabel, message: message, preferredStyle: .alert)
                    let proceed = UIAlertAction(title: "Proceed to pay", style: .default, handler: nil)
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(proceed)
                    alertController.addAction(cancel)
                    self.readerVC.present(alertController, animated: true, completion: nil)
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
            }
        }
    }
    
    
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
