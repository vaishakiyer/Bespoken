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
    var allNotifications: [BSNotification] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
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
            allNotifications.append(BSNotification("NEW COLLECTION ARRIVAL", "Checkout our new SpringLines! Order Now For delivery in Spring weather- in 10 to 14 days !", "redCircleFill"))
            allNotifications.append(BSNotification("NEW COLLECTION ARRIVAL", "Checkout our new SpringLines! Order Now For delivery in Spring weather- in 10 to 14 days !, Checkout our new SpringLines! Order Now For delivery in Spring weather- in 10 to 14 days !", "redCircleFill"))
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
        return allNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        cell.titleLabel.text = allNotifications[indexPath.row].title
        cell.notificationTextLabel.text = allNotifications[indexPath.row].text
        cell.imageView?.image = UIImage(named: allNotifications[indexPath.row].image!)

        return cell
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

extension NotificationViewController {
    func getNotificationsAPI() {
        Alamofire.request(Router.getNotifications()).responseJSON{
            response in

            switch response.result {
            case .success(let JSON):
                print("success")
            case .failure(let error):
                print("error")

                
            }
        }
    }
    func getWishlistItemsAPI(){
//        BSLoader.showLoading("", disableUI: true, image: "Group 376")
        Alamofire.request(Router.getNotifications()).responseJSON{
            response in
//            BSLoader.hide()

            switch response.result {
            case .success(let JSON):
                
                print("success")
            case .failure(let error):
                print("error")
            }
        }
    }
}
