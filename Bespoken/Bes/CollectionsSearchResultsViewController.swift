//
//  CollectionsSearchResultsViewController.swift
//  Bespoken
//
//  Created by Mohan on 29/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import Alamofire

class CollectionsSearchResultsViewController: UIViewController , UISearchResultsUpdating {
    
    @IBOutlet weak var collectionViewTags: UICollectionView!
    @IBOutlet weak var collectionViewResults: UICollectionView!
    var items = [UIImage(named: "collection8") , UIImage(named: "collection2"), UIImage(named: "collection3") ,  UIImage(named: "collection4"), UIImage(named: "collection5"), UIImage(named: "collection6"), UIImage(named: "collection7"), UIImage(named: "collection1"), UIImage(named: "collection9")]

    var allProducts : [Product] = []{
        didSet{
            for each in allProducts{
                for tag in each.tags{
                    tagsArray.append(tag)
                }
            }
            self.collectionViewTags.reloadData()
        }
    }
    
    var tagsArray : [String] = []
    var tagFlowLayout: UICollectionViewFlowLayout {
        get {
            return self.collectionViewTags.collectionViewLayout as! UICollectionViewFlowLayout
        }
    }
    
    var searchResultFlowLayout: UICollectionViewLayout {
        get {
            return self.collectionViewResults!.collectionViewLayout
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.collectionViewTags.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setup()
    }
    
    func setup() {
        
//        self.tagFlowLayout.scrollDirection = .horizontal
        collectionViewTags.delegate = self
        collectionViewTags.dataSource = self
        collectionViewResults.delegate = self
        collectionViewResults.dataSource = self
        getAllProductsAPI()
        if let layout = collectionViewResults?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
    }

}
extension CollectionsSearchResultsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewTags {
//            let width = self.collectionViewResults.frame.width / 3 - self.searchResultFlowLayout.minimumInteritemSpacing
            let cellSize : CGSize = CGSize(width: 100.0, height:  30.0)
            return cellSize
        } else {
            
//            let width = self.collectionViewResults.frame.width / 3 - self.searchResultFlowLayout.minimumInteritemSpacing
            let cellSize : CGSize = CGSize(width: self.view.frame.width, height:  100.0)
            return cellSize
        }
        
       

    }
}

extension CollectionsSearchResultsViewController : UICollectionViewDelegate{
    
}
extension CollectionsSearchResultsViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewTags{
            return self.tagsArray.count}
        else{
           return allProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewTags{
        let cell = self.collectionViewTags.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
        cell.tagLabel.text = tagsArray[indexPath.row]
            return cell

        }
        else {
            let cell = self.collectionViewResults.dequeueReusableCell(withReuseIdentifier: "ResultsCollectionViewCell", for: indexPath) as! ResultsCollectionViewCell
            cell.product = allProducts[indexPath.row]
            return cell

        }
    }
    
    func getAllProductsAPI(){
        Alamofire.request(Router.getAllProducts()).responseJSON(completionHandler: {(response) in
            
            switch response.result{
            case .success(let JSON):
                for each in (JSON as! [JSON]){
                    var product = Product(json: each as JSON)
                    self.allProducts.append(product)
                }
                self.collectionViewTags.reloadData()
                
            case .failure(let error):
                print(error)
            }
            
        })
    }
}
extension CollectionsSearchResultsViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        return (items[indexPath.item]?.size.height)!
    }
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return (items[indexPath.item]?.size.width)!
        
    }
}
