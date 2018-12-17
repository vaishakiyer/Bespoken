//
//  NotificationViewController.swift
//  Bespoken
//
//  Created by Mohan on 04/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import Alamofire

class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var segmentButton: UISegmentedControl!
    
//Mark :- Stored Variables
    var allNotifications: [BSNotification] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
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
        BSLoader.showLoading("", disableUI: true, image: "Group 376")
        Alamofire.request(Router.getNotifications()).responseJSON{
            response in
            BSLoader.hide()

            switch response.result {
            case .success(let JSON):
                print("success")
            case .failure(let error):
                print("error")
            }
        }
    }
}
