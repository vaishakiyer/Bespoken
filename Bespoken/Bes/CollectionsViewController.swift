//
//  CollectionsViewController.swift
//  Bespoken
//
//  Created by Mohan on 27/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import QRCodeReader
import ImageSlideshow
import Alamofire

class CollectionsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hamburgerMenu: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet weak var hamburgerMenuTableView: UITableView!
    @IBOutlet var shadowViewPanGestureRecogniser: UIPanGestureRecognizer!
    @IBOutlet var shadowViewTapGesture: UITapGestureRecognizer!
    @IBOutlet var screenEdgePanGesture: UIScreenEdgePanGestureRecognizer!
    
    //MARK: - Stored Variables
    var items = [UIImage(named: "collection8") , UIImage(named: "collection2"), UIImage(named: "collection3") ,  UIImage(named: "collection4"), UIImage(named: "collection5"), UIImage(named: "collection6"), UIImage(named: "collection7"), UIImage(named: "collection1"), UIImage(named: "collection9")]
    var hamburgerMenuItems = ["Elegant","Creative", "Sensual", "Extravagant"]
    var allProducts : [Product] = []

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    lazy var searchController: UISearchController = {
        
        let resultsController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionsSearchResultsViewController") as! CollectionsSearchResultsViewController
        let searchController = UISearchController(searchResultsController: resultsController)
        resultsController.searchBar = searchController.searchBar
        // Setup the Search Controller
        searchController.delegate = self
        searchController.searchResultsUpdater = resultsController
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search "
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.delegate = resultsController
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.setImage(UIImage(named: "qrcode"), for: .bookmark, state: .normal)
        
        return searchController
    }()
    
    
    //MARK: - IBActions
    @IBAction func onSearchTapped(_ sender: Any) {
        self.navigationItem.rightBarButtonItem = nil
        
        UIView.animate(withDuration: 0.3) {
            self.navigationItem.searchController = self.searchController
            self.searchController.isActive = true
        }
        self.view.layoutIfNeeded()
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
    override func viewDidDisappear(_ animated: Bool) {
        
//        if searchController.isActive == true {
//            
//            searchController.isActive = false
//            
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()
        definesPresentationContext = true
        collectionView.delegate = self
        collectionView.dataSource = self
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        self.getAllProductsAPI()


    }
    func initializeView()  {
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.hamburgerMenuLeftConstraint.constant = -self.hamburgerMenu.frame.size.width
        self.shadowView.alpha = 0
        self.shadowView.isHidden = true
        self.hamburgerMenuTableView.delegate = self
        self.hamburgerMenuTableView.dataSource = self
        self.hamburgerMenuTableView.tableFooterView = UIView()
        self.hamburgerMenuTableView.separatorStyle = .none
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(openMenu))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
//        self.navigationItem.rightBarButtonItem = searchButton
        self.title = "Collections"
        let motifView = UIImageView(image: UIImage(named: "Motif"))
        motifView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = motifView
    }
  @objc  func openSearch() {
        let resultsController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionsSearchResultsViewController") as! CollectionsSearchResultsViewController
        let searchController = UISearchController(searchResultsController: resultsController)
        // Setup the Search Controller
        searchController.delegate = self
        searchController.searchResultsUpdater = resultsController
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search "
        definesPresentationContext = true
       self.navigationItem.rightBarButtonItem = nil
    
        
                self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
//    self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
//self.present(searchController, animated: true, completion: nil)
    }
    

}


extension CollectionsViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        
        searchController.searchBar.becomeFirstResponder()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationItem.searchController = nil
        self.navigationItem.rightBarButtonItem = self.searchButton
        self.view.layoutIfNeeded()
    }
    
}
extension CollectionsViewController : UISearchBarDelegate{
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        readerVC.delegate = self
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)    }
}

extension CollectionsViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier:"CollectionsCollectionViewCell" , for: indexPath) as! CollectionsCollectionViewCell
        cell.delegate = self as CollectionsCollectionViewCellDelegate
        cell.indexPath = indexPath
        cell.product = self.allProducts[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ProductCheckoutController") as! ProductCheckoutController
        vc.theProduct = allProducts[indexPath.row]
        let navVC = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navVC, animated: true)
    }
}
extension CollectionsViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let imageUrl : String = allProducts[indexPath.row].images[0]
        return allProducts[indexPath.row].imageSizes[imageUrl]?.height ?? 100
    }
    func collectionView(_ collectionView: UICollectionView,
                        widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let imageUrl : String = allProducts[indexPath.row].images[0]
        return allProducts[indexPath.row].imageSizes[imageUrl]?.width ?? 100

    }
}


extension CollectionsViewController: CollectionsCollectionViewCellDelegate {
    func didFinishLoadingImage(_ cell: UICollectionViewCell) {
        
        let cell = cell as! CollectionsCollectionViewCell
        self.collectionView.reloadItems(at: [cell.indexPath!])
    
    }
    
    
}

extension CollectionsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 4
        default:
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
//        let label = UILabel()
//        label.adjustsFontSizeToFitWidth = true
//        label.adjustsFontForContentSizeCategory = true
//
//        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//        label.textColor = UIColor.black
//        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTap))
//        tap.delegate = self
//        switch section {
//        case 0:
//            label.text = "Home"
//            headerView.addGestureRecognizer(tap)
//
//        case 1:
//            label.text = "Filter"
//        default:
//            print("out of index in section")
//        }
//
//        headerView.addSubview(label)
//        return headerView
//
//    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
                    case 0:
                        return "Home"
                    case 1:
                        return "Filter"
                    default:
                        print("out of index in section")
                        return "Error"
                    }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTap))
            tap.delegate = self
            let headerView = UITableViewHeaderFooterView()
            if section == 0 {
                headerView.addGestureRecognizer(tap)
            }
        
            return headerView
    }
    @objc func handleTap(){
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.hamburgerMenuTableView.dequeueReusableCell(withIdentifier: "HamburgerMenuTableViewCell") as! UITableViewCell
        cell.textLabel?.text = self.hamburgerMenuItems[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 16)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hideMenu()
        self.collectionView.reloadData()
    }
    

}
//Mark :- For HamburgerMenu
extension CollectionsViewController{
   @objc func openMenu() {
        
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
extension CollectionsViewController : QRCodeReaderViewControllerDelegate,EnlargeImageDelegate{
    func openImage(sender: ImageSlideshow) {
        
        sender.presentFullScreenController(from: self)
    }
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print(result.value)
        
        let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "")
//        productDetailVC.productId = result.value
        self.navigationController?.pushViewController(productDetailVC!, animated: true)
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        print("Action Cancelled")
        dismiss(animated: true, completion: nil)
    }
    
}
extension CollectionsViewController{
    func getAllProductsAPI(){
        Alamofire.request(Router.getAllProducts()).responseJSON(completionHandler: {(response) in
            
            switch response.result{
            case .success(let JSON):
                for each in (JSON as! [JSON]){
                    var product = Product(json: each as JSON)
                    self.allProducts.append(product)
                }
                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
          
        })
    }
}
extension CollectionsViewController : UIGestureRecognizerDelegate{
    
}
