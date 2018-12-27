//
//  NotificationViewController.swift
//  Bespoken
//
//  Created by Mohan on 04/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import Alamofire
import QRCodeReader

class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var segmentButton: UISegmentedControl!
    
    //Mark :- Stored Variables
    var allNotifications: [BSNotification] = []
    var allwishlistProducts : [Product] = []
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()

    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        if  segmentButton.selectedSegmentIndex == 1
        {
            getNotificationsAPI()
//            allNotifications.append(BSNotification("NEW COLLECTION ARRIVAL", "Checkout our new SpringLines! Order Now For delivery in Spring weather- in 10 to 14 days !", "redCircleFill"))
//            allNotifications.append(BSNotification("NEW COLLECTION ARRIVAL", "Checkout our new SpringLines! Order Now For delivery in Spring weather- in 10 to 14 days !, Checkout our new SpringLines! Order Now For delivery in Spring weather- in 10 to 14 days !", "redCircleFill"))
        }
        else{
//            allNotifications.removeAll()
            getWishlistItemsAPI()
        }
        

    }
    
    
    func initializeView()  {
        self.title = "Notifications and Wishlist"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension

        self.tableView.estimatedRowHeight  = 40
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "qrcode"), style: .plain, target: self, action: #selector(openQRScanner))
        self.getWishlistItemsAPI()
        self.getNotificationsAPI()
      //  segmentButton.selectedSegmentIndex = 0
//       if  segmentButton.selectedSegmentIndex == 0
//       {
//        allNotifications.append(BSNotification("NEW COLLECTION ARRIVAL", "Checkout our new SpringLines! Order Now For delivery in Spring weather- in 10 to 14 days !", "redCircleFill"))
//        allNotifications.append(BSNotification("NEW COLLECTION ARRIVAL", "Checkout our new SpringLines! Order Now For delivery in Spring weather- in 10 to 14 days !, Checkout our new SpringLines! Order Now For delivery in Spring weather- in 10 to 14 days !", "redCircleFill"))
//        }
//       else{
//        allNotifications.removeAll()
//        }
    }
    @objc func openQRScanner(){
        readerVC.delegate = self
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    


}

//Mark : - Table View functions
extension NotificationViewController : UITableViewDelegate {
    
    
}
extension NotificationViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentButton.selectedSegmentIndex == 0{
            return 1
        }else{
            return allNotifications.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentButton.selectedSegmentIndex == 0{
            return 1
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if segmentButton.selectedSegmentIndex == 0{
        return 50
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if segmentButton.selectedSegmentIndex == 0{
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.textColor = UIColor.black
        
        label.text = "Vaishak's Wishlist "
        label.adjustsFontSizeToFitWidth = true
        headerView.addSubview(label)
            return headerView}
        else{
        return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentButton.selectedSegmentIndex == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "WishlistTableViewCell") as! WishlistTableViewCell
            cell.wishlistProducts = self.allwishlistProducts
            return cell
        }
        else{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        if segmentButton.selectedSegmentIndex == 1{
        cell.titleLabel.text = allNotifications[indexPath.row].message
        cell.timeLabel.text = allNotifications[indexPath.row].updatedDate
        }
//        cell.notificationTextLabel.text = allwishlistProducts[indexPath.row].text
//        cell.imageView?.image = UIImage(named: allNotifications[indexPath.row].image!)
        return cell
        }
    }
    
    
    
}
extension NotificationViewController : QRCodeReaderViewControllerDelegate{
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print(result.value)
        
        //        productDetailVC.productId = result.value
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "ProductCheckoutController") as? ProductCheckoutController
        nextVC?.theProductId = result.value
        self.navigationController?.pushViewController(nextVC!, animated: true)
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        print("Action Cancelled")
        dismiss(animated: true, completion: nil)
    }
    
}
extension NotificationViewController : UICollectionViewDelegate{
    
}
extension NotificationViewController {
    func getNotificationsAPI() {
        Alamofire.request(Router.getNotifications()).responseJSON{
            response in

            switch response.result {
            case .success(let JSON):
                self.allNotifications.removeAll()
                if let notif = JSON as? [JSON]{
                    for each in notif{
                        let newNotif = BSNotification(with: each)
                        self.allNotifications.append(newNotif)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("success")
            case .failure(let error):
                print("error")

                
            }
        }
    }
    func getWishlistItemsAPI(){
        BSLoader.showLoading("", disableUI: true, image: "Group 376")
        Alamofire.request(Router.getWishlistItems()).responseJSON{
            response in
            BSLoader.hide()

            switch response.result {
            case .success(let JSON):
                self.allwishlistProducts.removeAll()
                let products :[JSON] = (JSON as! [JSON])//["products"] as! [JSON] 
                    for each in products {
                        let newProd = Product(json: each)
                        self.allwishlistProducts.append(newProd)
                    }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(response.request)
                print("Wishlist Products cunt is \(self.allwishlistProducts.count)")
            case .failure(let error):
                print("error")
            }
        }
    }
}

