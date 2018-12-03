//
//  PreviewImageCollectionViewCell.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 23/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit



class PreviewImageCollectionViewCell: UICollectionViewCell {
    
    
    var releaseDate: Date?
    var countdownTimer = Timer()
    var setDate = String(){
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var countDownLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // let releaseDateString = "2018-11-24 23:00:00"
        
        // Initialization code
    }
    
    func updateUI(){
        
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        releaseDate = releaseDateFormatter.date(from: setDate)!  as Date
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTime() {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)
        
        let countdown = "Days \(diffDateComponents.day ?? 0), Hours \(diffDateComponents.hour ?? 0), Minutes \(diffDateComponents.minute ?? 0), Seconds \(diffDateComponents.second ?? 0)"
        
        countDownLabel.text = countdown
       
    }
   

}
