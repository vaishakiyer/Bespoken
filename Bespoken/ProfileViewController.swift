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
//        self.shadowView.dropShadow(color: UIColor.black, offSet: CGSize(width: 10, height: 10))
        let progressBar = YLProgressBar(frame: self.progressView.frame)
        progressBar.cornerRadius = 0
        progressBar.progressTintColor = UIColor.black
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: progressBar, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: progressView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: progressBar, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: progressView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: progressBar, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: progressView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: progressBar, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: progressView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        progressBar.addConstraints([leftConstraint, rightConstraint ,topConstraint, bottomConstraint])
        self.progressView.addSubview(progressBar)
    }
    

}
