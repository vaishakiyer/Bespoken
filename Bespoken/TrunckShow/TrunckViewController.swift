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
    @IBOutlet weak var pageControl: UIPageControl!
    let segment: UISegmentedControl = UISegmentedControl(items: ["First", "Second"])
   
    
    
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
    var allProducts : [Product] = []
    var completeAnsHandler : ((_ value: String,_ trunckId: String) -> [UIViewController])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setup()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func setup(){
    
        segment.sizeToFit()
        segment.tintColor = UIColor(red:1, green:1, blue:1, alpha:1.00)
        segment.selectedSegmentIndex = 0;
        segment.addTarget(self, action: #selector(segementChanged(sender:)), for: .allEvents)
        self.navigationItem.titleView = segment
    
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
    
    func createNavbar(shouldHide: Bool){
        
        if shouldHide == false{
            let rsvpButton = UIBarButtonItem(title: "RSVP", style: .plain, target: self, action: #selector(rsvpPressed))
            rsvpButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = rsvpButton
        }else{
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        }
    }
    
    @objc func rsvpPressed(){
        
        if myGroupedEvents[selectedSection][selectedIndex].seatsAvailable! > 0{
             createRSVP()
        }else{
            self.showAlert(message: "Oops!! \n There are no seats available currently. \n Please talk to the event coordinator for further info.")
        }
        
       
    }
    
    @objc func segementChanged(sender: UISegmentedControl){
        
        switch sender.selectedSegmentIndex {
        case 0:
            
            break
        default:
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "List2ViewController") as? List2ViewController
            let nc = UINavigationController(rootViewController: nextVC!)
            nextVC?.presentHandler = { () -> Void in
                
                self.segment.selectedSegmentIndex = 0
                
            }
            nc.modalPresentationStyle = .fullScreen
            self.present(nc, animated: true, completion: nil)
        }
        
        
        
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
        
        
        if let layout = trunckCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        createNavbar(shouldHide: true)
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
extension TrunckViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mySections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if previewButtonPressed == true{
             return 1
        }else{
            
            pageControl.numberOfPages = myGroupedEvents[section].count
            pageControl.isHidden = !(myGroupedEvents[section].count > 1)
             return myGroupedEvents[section].count
        }
       
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if previewButtonPressed == true{
        return CGSize(width: self.view.frame.width, height: 144)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if previewButtonPressed == true{

             let sectionHeader = trunckCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader
            
            if let startTime = myGroupedEvents[selectedSection][selectedIndex].endDate{
                sectionHeader!.setDate = startTime
            }
            
            if let val = myGroupedEvents[selectedSection][selectedIndex].seatsAvailable{
                 sectionHeader?.updateSeats(count: val)
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
        
        
        self.completeAnsHandler("F2TrunckShow",myGroupedEvents[indexPath.section][indexPath.row].id!)
       // self.navigationController?.popViewController(animated: true)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if previewButtonPressed == true{
            return CGSize(width: self.view.frame.width, height: 390)
        }else{
            return CGSize(width: self.view.frame.width - 20, height: 550)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: self.view.frame.width / 2 - 145, bottom: 0, right: self.view.frame.width / 2 - 145)
    }
    
    
}

extension TrunckViewController: TrunckViewDelegate{
    
    func buttonPreviewPressed(sender: TrunckViewCell) {
        
        guard let tappedIndex  = trunckCollection.indexPath(for: sender) else {return}
        
        if let layout = trunckCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
        selectedIndex = tappedIndex.item
        selectedSection = tappedIndex.section
        previewButtonPressed = true
         addGestureToView()
        innerView.isHidden = false
        createNavbar(shouldHide: false)
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

extension TrunckViewController{
    
    func getEvents(){
        
         BSLoader.showLoading("", disableUI: true, image: "Group 376")
        
        Alamofire.request(Router.getEvents(lat: myLocation.latitude!, long: myLocation.longitude!)).responseJSON { (response) in
            
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
    
    func createRSVP(){
        
        Alamofire.request(Router.rsvpEvent(eventId: myGroupedEvents[selectedSection][selectedIndex].id!, status: "YES")).responseJSON { (response) in
            
            switch response.result{
                
            case .success(let JSON):
                
             print(JSON)
                
             if let statusMessage = (JSON as? NSDictionary)?.value(forKeyPath: "data.result") as? String{
                
                if statusMessage == "success"{
                    self.showAlert(message: "Congratulations!! \n\n You have been invited to the event successfully")
                }
                
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
            }
            
            
            
        }
        
        
    }
    
    
}
