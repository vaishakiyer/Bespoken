//
//  CollectionsViewController.swift
//  Bespoken
//
//  Created by Mohan on 27/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController {
    var items = [UIImage(named: "collection8") , UIImage(named: "collection2"), UIImage(named: "collection3") ,  UIImage(named: "collection4"), UIImage(named: "collection5"), UIImage(named: "collection6"), UIImage(named: "collection7"), UIImage(named: "collection1"), UIImage(named: "collection9")]
    var hamburgerMenuItems = ["Home","Wishlist", "Bag","My Profile", "Notifications"]

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hamburgerMenu: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var hamburgerMenuWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hamburgerMenuTableView: UITableView!
    @IBOutlet var shadowViewPanGestureRecogniser: UIPanGestureRecognizer!
    @IBOutlet var shadowViewTapGesture: UITapGestureRecognizer!
    @IBOutlet var screenEdgePanGesture: UIScreenEdgePanGestureRecognizer!
    
    @IBAction func onSearchTapped(_ sender: Any) {
        let resultsController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionsSearchResultsViewController")
        let searchController = UISearchController(searchResultsController: resultsController)
        // Setup the Search Controller
        searchController.searchResultsUpdater = resultsController as? UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search "
//        self.navigationBarTitle.searchController = searchController
//        self.navigationBarTitle.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = true
        self.present(searchController, animated: true)
        definesPresentationContext = true

        
    }
    @IBOutlet weak var hamburgerMenuLeftConstraint: NSLayoutConstraint!
    @IBAction func gestureTap(_ sender: UITapGestureRecognizer) {
        self.hideMenu()
    }
    @IBAction func hamburgerMenuButton(_ sender: Any) {
        self.openMenu()
    }
    
    @IBAction func gestureScreenEdgePan(_ sender: UIScreenEdgePanGestureRecognizer) {
        
        // retrieve the current state of the gesture
        if sender.state == UIGestureRecognizer.State.began {
            
            // if the user has just started dragging, make sure view for dimming effect is hidden well
            shadowView.isHidden = false
            shadowView.alpha = 0
        } else if (sender.state == UIGestureRecognizer.State.changed) {
            
            // retrieve the amount viewMenu has been dragged
            let translationX = sender.translation(in: sender.view).x
            if -self.hamburgerMenu.frame.size.width + translationX > 0 {
                
                // viewMenu fully dragged out
                hamburgerMenuLeftConstraint.constant = 0
                shadowView.alpha = 1
            } else if translationX < 0 {
                
                // viewMenu fully dragged in
                hamburgerMenuLeftConstraint.constant = -hamburgerMenuLeftConstraint.constant
                shadowView.alpha = 0
            } else {
                
                // viewMenu is being dragged somewhere between min and max amount
                hamburgerMenuLeftConstraint.constant = -hamburgerMenuLeftConstraint.constant + translationX
                
                let ratio = translationX / self.hamburgerMenu.frame.size.width
                let alphaValue = ratio * 1
                shadowView.alpha = alphaValue
            }
        } else {
            
            // if the menu was dragged less than half of it's width, close it. Otherwise, open it.
            if self.hamburgerMenu.frame.size.width < -self.hamburgerMenu.frame.size.width / 2 {
                self.hideMenu()
            } else {
                self.openMenu()
            }
        }
    }
    @IBAction func gesturePan(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
        } else if sender.state == UIGestureRecognizer.State.changed {
            
            // retrieve the amount viewMenu has been dragged
            let translationX = sender.translation(in: sender.view).x
            if translationX > 0 {
                
                // viewMenu fully dragged out
                hamburgerMenuLeftConstraint.constant = 0
                shadowView.alpha = 1
            } else if translationX < -hamburgerMenu.frame.size.width {
                
                // viewMenu fully dragged in
                hamburgerMenuLeftConstraint.constant = -hamburgerMenu.frame.size.width
                shadowView.alpha = 0
            } else {
                
                // it's being dragged somewhere between min and max amount
                hamburgerMenuLeftConstraint.constant = translationX
                
                let ratio = (hamburgerMenu.frame.size.width  + translationX) / hamburgerMenu.frame.size.width
                let alphaValue = ratio * 1
                shadowView.alpha = alphaValue
            }
        } else {
            
            // if the drag was less than half of it's width, close it. Otherwise, open it.
            if hamburgerMenuLeftConstraint.constant < -hamburgerMenu.frame.size.width / 2 {
                self.hideMenu()
            } else {
                self.openMenu()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()
        collectionView.delegate = self
        collectionView.dataSource = self
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }


    }
    func initializeView()  {
        self.hamburgerMenuLeftConstraint.constant = -self.hamburgerMenu.frame.size.width
        self.shadowView.alpha = 0
        self.shadowView.isHidden = true
        self.hamburgerMenuTableView.delegate = self
        self.hamburgerMenuTableView.dataSource = self
        self.hamburgerMenuTableView.tableFooterView = nil
//        self.navigationItem.largeTitleDisplayMode = .automatic
//        self.navigationBar.prefersLargeTitles = true
//        self.navigationBarTitle.largeTitleDisplayMode = .automatic
    }
    

}

extension CollectionsViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier:"CollectionsCollectionViewCell" , for: indexPath) as! CollectionsCollectionViewCell
        cell.imageView.image = items[indexPath.row]!
        cell.imageView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.imageView.layer.shadowRadius = 5
        cell.imageView.layer.shadowOpacity = 1
        cell.imageView.layer.shadowOffset = CGSize.zero

        return cell
    }
    
    
}
extension CollectionsViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        return (items[indexPath.item]?.size.height)!
    }
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return (items[indexPath.item]?.size.width)!

    }
}
extension CollectionsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.hamburgerMenuTableView.dequeueReusableCell(withIdentifier: "HamburgerMenuTableViewCell") as! UITableViewCell
        cell.textLabel?.text = self.hamburgerMenuItems[indexPath.row]
        return cell
    }
    

}
// For HamburgerMenu
extension CollectionsViewController{
    func openMenu() {
        
        self.hamburgerMenuLeftConstraint.constant = 0

        shadowView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.shadowView.alpha = 0.7
        }, completion: { (complete) in
            print("Opened Hamburger Menu")
            self.screenEdgePanGesture.isEnabled = false
        })
    }
    func hideMenu() {
        
        self.hamburgerMenuLeftConstraint.constant = -self.hamburgerMenu.frame.size.width
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.shadowView.alpha = 0
        }, completion: { (complete) in
                self.screenEdgePanGesture.isEnabled = true
            print("Opened Hamburger Menu")

            self.shadowView.isHidden = true
        })
    }
}
