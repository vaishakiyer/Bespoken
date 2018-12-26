//
//  ProfileViewController.swift
//  Bespoken
//
//  Created by Mohan on 13/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import YLProgressBar
import Alamofire

class ProfileViewController: UIViewController {

    @IBOutlet var tableHeaderTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var progressView: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var shadowView: UIView!
    @IBAction func logoutButtonPressed(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup()  {
        self.profileImage.image =  self.profileImage.image?.af_imageRounded(withCornerRadius: 500)
        self.logoutButton.roundCorners(corners: UIRectCorner(arrayLiteral: .allCorners), radius: 20)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = nil
 
        let styleWords = BSUserDefaults.getLoggedWords()
        if styleWords == nil {
            self.getStylewords()

        }
        var x  = ""
        for i in styleWords ?? []{
     
            x = x + i + " - "
            
        }
        tableHeaderTitle.text = x
        
//        self.shadowView.dropShadow(color: UIColor.black, offSet: CGSize(width: 10, height: 10))
        let progressBar = YLProgressBar(frame: self.progressView.bounds)
        progressBar.cornerRadius = 0
        progressBar.progressTintColor = UIColor.black
        self.progressView.addSubview(progressBar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: progressBar, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: progressView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: progressBar, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: progressView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: progressBar, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: progressView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: progressBar, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: progressView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        progressView.addConstraints([leftConstraint, rightConstraint ,topConstraint, bottomConstraint])
        
    }
    

}
extension ProfileViewController : UITableViewDelegate{
    
}
extension ProfileViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileTimelineTableViewCell") as! ProfileTimelineTableViewCell
        cell.indexPath = indexPath
        return cell
    }
    
    
}
extension ProfileViewController {
    
    func getStylewords(){
        
        Alamofire.request(Router.getStyleWords()).responseJSON { (response) in
            
            switch response.result{
                
            case .success(let JSON):
                
                print(JSON)
                
                guard let wordList = (JSON as? NSDictionary)?.value(forKey: "words") as? [String] else {return}
                
                BSUserDefaults.setLoggedWords(wordList)
                
                self.tableView.reloadData()
                //   self.creativeLabel.text = labelValue
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            
        }
        
        
    }
    
}
