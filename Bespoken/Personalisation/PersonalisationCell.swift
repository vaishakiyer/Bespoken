//
//  PersonalisationCell.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 18/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class PersonalisationCell: UITableViewCell {
    
    
    @IBOutlet weak var optionCollection: UICollectionView!
    
    var dummyArray = [String](){
        didSet{
            optionCollection.reloadData()
        }
    }
    var segmentIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionCollection.register(UINib(nibName: "OptionsViewCell", bundle: nil), forCellWithReuseIdentifier: "OptionsViewCell")
        optionCollection.delegate = self
        optionCollection.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}

extension PersonalisationCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return dummyArray.count
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = optionCollection.dequeueReusableCell(withReuseIdentifier: "OptionsViewCell", for: indexPath) as? OptionsViewCell
        
        
          cell?.titleLabel.text = dummyArray[indexPath.row]
        
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 120, height: 40)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        if segmentIndex != nil && segmentIndex == 2{
            
            return UIEdgeInsets(top: 30, left: self.frame.width / 2 - 60, bottom: 30, right: self.frame.width / 2 - 60)
            
        }else{
            return UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        }
        
        
        
    }
    
    
    
    
    
}

