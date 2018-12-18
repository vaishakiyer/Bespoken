//
//  ProfileViewController.swift
//  Bespoken
//
//  Created by Mohan on 13/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import YLProgressBar

class ProfileViewController: UIViewController {

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
        self.shadowView.dropShadow(color: UIColor.black, offSet: CGSize(width: 10, height: 10))
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
