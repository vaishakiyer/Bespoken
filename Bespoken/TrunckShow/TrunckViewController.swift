//
//  TrunckViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 23/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import AlamofireImage
import Alamofire
import ImageSlideshow

class TrunckViewController: UIViewController {

    @IBOutlet weak var trunckCollection: UICollectionView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var trunkLogo: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var titleDesc: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    
    
    var tap = UITapGestureRecognizer()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    var previewButtonPressed: Bool? = false
    var selectedIndex: Int!
    var selectedSection : Int!
    var mySections = [String]()
    var myEvents = TrunckShow()
    var myGroupedEvents = [TrunckShow]()
    var completeAnsHandler : ((_ value: String) -> UIViewController)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setup()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func setup(){
        
        self.navigationItem.title = "EVENTS"
        trunckCollection.delegate = self
        trunckCollection.dataSource = self
        trunckCollection.register(UINib(nibName: "TrunckViewCell", bundle: nil), forCellWithReuseIdentifier: "TrunckViewCell")
        trunckCollection.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
         trunckCollection.register(UINib(nibName: "eventsHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "eventsHeader")
        trunckCollection.register(UINib(nibName: "PreviewImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PreviewImageCollectionViewCell")
        getEvents()
        innerView.roundCorners(corners: .allCorners, radius: 12)
        innerView.isHidden = true
    }
    
    func updateUI() {
        
        if let url = URL(string: myGroupedEvents[selectedSection][selectedIndex].bannerImage!){
            trunkLogo.af_setImage(withURL: url)
        }
        
        titleName.text = myGroupedEvents[selectedSection][selectedIndex].organizerName
        titleDesc.text = myGroupedEvents[selectedSection][selectedIndex].description
        
        let releaseDate: Date?
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        releaseDate = releaseDateFormatter.date(from: myGroupedEvents[selectedSection][selectedIndex].startDate!)!  as Date
        releaseDateFormatter.dateFormat = "dd-MMM-YYYY"
        let startDate = releaseDateFormatter.string(from: releaseDate!)
        eventDate.text = startDate
        
        eventLocation.text = myGroupedEvents[selectedSection][selectedIndex].location
        
        
    }
    
    func addGestureToView(){
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(){
        
        previewButtonPressed = false
        innerView.isHidden = true
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
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mySections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if previewButtonPressed == true{
             return 1
        }else{
             return myGroupedEvents[section].count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if previewButtonPressed == true{
        return CGSize(width: self.view.frame.width, height: 144)
        }else{
            return CGSize(width: self.view.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if previewButtonPressed == true{

             let sectionHeader = trunckCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader
            
            if let startTime = myGroupedEvents[selectedSection][selectedIndex].startDate{
                sectionHeader!.setDate = startTime
            }
            
            return sectionHeader!
            
        }else{
            
            let header = trunckCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "eventsHeader", for: indexPath) as? eventsHeader
            header?.titleLabel.text = mySections[indexPath.row]
            
             return header!
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if previewButtonPressed == true{
            
            let cell = trunckCollection.dequeueReusableCell(withReuseIdentifier: "PreviewImageCollectionViewCell", for: indexPath) as? PreviewImageCollectionViewCell
            cell?.imageList.removeAll()
            cell!.delegate = self
            if let urls = URL(string: myGroupedEvents[indexPath.section][selectedIndex].bannerImage!){
                
               cell!.imageList.append(AlamofireSource(url: urls))
             //   cell!.previewImage.af_setImage(withURL: url)
            }
            
           
            return cell!
            
        }else{
            
            let cell = trunckCollection.dequeueReusableCell(withReuseIdentifier: "TrunckViewCell", for: indexPath) as? TrunckViewCell
            
            if let url = URL(string: myGroupedEvents[indexPath.section][indexPath.item].bannerImage!){
                cell!.bkgImage.af_setImage(withURL: url)
            }
            
            cell!.delegate = self
            return cell!
        }
        
       
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        self.completeAnsHandler("F2TrunckShow")
        self.navigationController?.popViewController(animated: true)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if previewButtonPressed == true{
            return CGSize(width: self.view.frame.width, height: 390)
        }else{
            return CGSize(width: 290, height: 50)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    }
    
    
}

extension TrunckViewController: TrunckViewDelegate{
    
    func buttonPreviewPressed(sender: TrunckViewCell) {
        
        guard let tappedIndex  = trunckCollection.indexPath(for: sender) else {return}
        
        selectedIndex = tappedIndex.item
        selectedSection = tappedIndex.section
        previewButtonPressed = true
         addGestureToView()
        innerView.isHidden = false
        
        updateUI()
        
        UIView.transition(with: trunckCollection, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            //Do the data reload here
            self.trunckCollection.performBatchUpdates({
                let indexSet = IndexSet(integersIn: 0...0)
                self.trunckCollection.reloadSections(indexSet)
            }, completion: nil)
            
        }, completion: nil)

    }
    
    func scanButtonPressed(sender: TrunckViewCell){
        
        readerVC.delegate = self
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
        
    }
    
    
}

extension TrunckViewController: QRCodeReaderViewControllerDelegate,EnlargeImageDelegate{
    func openImage(sender: ImageSlideshow) {
        
        sender.presentFullScreenController(from: self)
    }
    
    
    
    
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print(result.value)
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        print("Action Cancelled")
         dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Network Operation

extension TrunckViewController{
    
    func getEvents(){
        
         BSLoader.showLoading("", disableUI: true, image: "Group 376")
        
        Alamofire.request(Router.getEvents()).responseJSON { (response) in
            
            BSLoader.hide()
            
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
