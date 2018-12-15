//
//  CollectionsSearchResultsViewController.swift
//  Bespoken
//
//  Created by Mohan on 29/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class CollectionsSearchResultsViewController: UIViewController , UISearchResultsUpdating {
    
    @IBOutlet weak var collectionViewTags: UICollectionView!
    @IBOutlet weak var collectionViewResults: UICollectionView!
    
    
    var tagsArray : [String] = []
    var tagFlowLayout: UICollectionViewFlowLayout {
        get {
            return self.collectionViewTags.collectionViewLayout as! UICollectionViewFlowLayout
        }
    }
    
    var searchResultFlowLayout: UICollectionViewFlowLayout {
        get {
            return self.collectionViewResults.collectionViewLayout as! UICollectionViewFlowLayout
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
        
        self.tagFlowLayout.scrollDirection = .horizontal
        self.searchResultFlowLayout.scrollDirection = .vertical
        self.tagsArray  = ["Sensual", "Sensual","Sensual","Sensual","Sensual", "Sensual","Sensual","Sensual"]
        collectionViewTags.delegate = self
        collectionViewTags.dataSource = self
        collectionViewResults.delegate = self
        collectionViewResults.dataSource = self
        
        
    }

}
extension CollectionsSearchResultsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewTags {
//            let width = self.collectionViewResults.frame.width / 3 - self.searchResultFlowLayout.minimumInteritemSpacing
            let cellSize : CGSize = CGSize(width: 100.0, height:  100.0)
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
        return self.tagsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewTags{
        let cell = self.collectionViewTags.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
        cell.tagLabel.text = tagsArray[indexPath.row]
            return cell

        }
        else {
            let cell = self.collectionViewResults.dequeueReusableCell(withReuseIdentifier: "ResultsCollectionViewCell", for: indexPath) as! ResultsCollectionViewCell
            return cell

        }
    }
}
