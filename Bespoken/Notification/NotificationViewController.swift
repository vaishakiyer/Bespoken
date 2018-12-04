//
//  NotificationViewController.swift
//  Bespoken
//
//  Created by Mohan on 04/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
//Mark :- Stored Variables
    var allNotifications: [BSNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()

    }
    
    func initializeView()  {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight  = 40
        allNotifications.append(BSNotification("NEW COLLECTION ARRIVAL", "Checkout our new SpringLines! Order Now For delivery in Spring weather- in 10 to 14 days !"))
        allNotifications.append(BSNotification("NEW COLLECTION ARRIVAL", "Checkout our new SpringLines! Order Now For delivery in Spring weather- in 10 to 14 days !"))
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

        return cell
    }
    
    
    
}
