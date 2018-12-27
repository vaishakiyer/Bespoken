//
//  PersonalisationCell.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 18/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

protocol optionsDelegate {
    func didSelectOption(forQuestion : QuestionnaireElement  , selectedOption : Option, sender: UITableViewCell, tab: Int)
    func didSelectAll(tab: Int, forQuestion : QuestionnaireElement , options : [Option], sender: UITableViewCell)
}

class PersonalisationCell: UITableViewCell {
    
    
    @IBOutlet weak var optionCollection: UICollectionView!
    var question : QuestionnaireElement?
    var answerOptions = [Option](){
        didSet{
            optionCollection.reloadData()
        }
    }
    var delegate :optionsDelegate?
    var segmentIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionCollection.register(UINib(nibName: "OptionsViewCell", bundle: nil), forCellWithReuseIdentifier: "OptionsViewCell")
        optionCollection.delegate = self
        optionCollection.dataSource = self
        if let layout = optionCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
}

extension PersonalisationCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentIndex == 2{
            return answerOptions.count + 1
        }else{
            return answerOptions.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = optionCollection.dequeueReusableCell(withReuseIdentifier: "OptionsViewCell", for: indexPath) as? OptionsViewCell
        if indexPath.row == answerOptions.count && segmentIndex == 2{
            cell?.titleLabel.text = "All"
            cell?.titleLabel.backgroundColor = UIColor.groupTableViewBackground
            return cell!
        }
        else{
            cell?.titleLabel.text = answerOptions[indexPath.row].text?.uppercased()
            
            if answerOptions[indexPath.row].archived == true{
                cell!.titleLabel.backgroundColor = UIColor.gray
            }
            else{
                cell!.titleLabel.backgroundColor = UIColor.groupTableViewBackground
            }
            return cell!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 120, height: 40)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        if segmentIndex != nil && segmentIndex == 2{
            
//            return UIEdgeInsets(top: 30, left: self.frame.width / 2 - 60, bottom: 30, right: self.frame.width / 2 - 60)
            return UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)

            
        }else{
            return UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        }
        
        
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == answerOptions.count && segmentIndex == 2{
            delegate!.didSelectAll(tab: 2, forQuestion: self.question! , options: self.answerOptions, sender: self)
        }
        else{
            delegate?.didSelectOption(forQuestion: self.question!, selectedOption: answerOptions[indexPath.row],sender: self, tab: self.segmentIndex!)
        }
    }
}

