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

    var searchBar : UISearchBar?
    var allProducts : [Product] = []
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
        let searchText : String = searchController.searchBar.text ?? ""
        if searchText != "" {
        self.getResultsforSearchText(searchText : searchText)
        }
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
        
//        if collectionView == collectionViewTags {
//            let width = self.collectionViewResults.frame.width / 3 - self.searchResultFlowLayout.minimumInteritemSpacing
            let cellSize : CGSize = CGSize(width: 100.0, height:  30.0)
            return cellSize
//        }
    }
}

extension CollectionsSearchResultsViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewTags{
            self.searchBar?.text = tagsArray[indexPath.row]
    }
        else{
//            self.dismiss(animated: false) 
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "ProductCheckoutController") as! ProductCheckoutController
                vc.theProduct = self.allProducts[indexPath.row]
            let navVC = UINavigationController(rootViewController: vc)
            self.presentingViewController!.present(navVC, animated: true)
//            self.present(navVC, animated: true)
            self.navigationController?.pushViewController(navVC, animated: true)

        }
}
}
extension CollectionsSearchResultsViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewTags{
            return self.tagsArray.count
        }
        else{
           return allProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewTags{
        let cell = self.collectionViewTags.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
        cell.tagLabel.text = tagsArray[indexPath.row].uppercased()
            return cell

        }
        else {
            let cell = self.collectionViewResults.dequeueReusableCell(withReuseIdentifier: "ResultsCollectionViewCell", for: indexPath) as! ResultsCollectionViewCell
            cell.delegate = self
            cell.indexPath = indexPath
            cell.product = allProducts[indexPath.row]
            return cell

        }
    }
    
}
extension CollectionsSearchResultsViewController: PinterestLayoutDelegate {
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
extension CollectionsSearchResultsViewController : UISearchBarDelegate{
    
}
extension CollectionsSearchResultsViewController : ResultsCollectionViewCellDelegate{
        func didFinishLoadingImage(_ cell: UICollectionViewCell) {
            let cell = cell as! ResultsCollectionViewCell
            self.collectionViewResults.reloadItems(at: [cell.indexPath!])
        }
}
extension CollectionsSearchResultsViewController{
    func getResultsforSearchText(searchText : String) {
        Alamofire.request(Router.ProductSearch(searchText: searchText)).responseJSON(completionHandler: {
        (response) in
            switch response.result{
            case .success(let JSON):
                self.allProducts.removeAll()
                self.tagsArray.removeAll()
                
                let products : [JSON] = (JSON as! JSON)["products"] as! [JSON]
                let recommendedTags : [String] = (JSON as! JSON)["recommended_tags"] as! [String]
                for each in products{
                    var product = Product(json: each as JSON)
                    self.allProducts.append(product)
                }
                self.tagsArray = recommendedTags
                DispatchQueue.main.async {
                    self.collectionViewTags.reloadData()
                    self.collectionViewResults.reloadData()
                }
         
                print("product search api called for text \(searchText)")
                print(self.allProducts.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    )
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
                print(error.localizedDescription)
            }
            
        })
    }
}
