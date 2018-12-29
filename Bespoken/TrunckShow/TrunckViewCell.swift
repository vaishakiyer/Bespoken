//
//  TrunckViewCell.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 23/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import CountdownLabel

protocol RSVPDelegate {
    func rsvpPressed(sender: TrunckViewCell)
}

class TrunckViewCell: UICollectionViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var scannerButton: UIButton!
    @IBOutlet weak var bkgImage: UIImageView!
    
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var countdownLabel: CountdownLabel!
    @IBOutlet weak var rsvpButton: UIButton!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var inviteImage: UIImageView!
    
    
    var delegate : RSVPDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        outerView.roundCorners(corners: .allCorners, radius: 24)
        rsvpButton.roundCorners(corners: .allCorners, radius: 8)
        rsvpButton.addTarget(self, action: #selector(rsvpClicked), for: .touchUpInside)
      //  gifView.loadGif(name: "Ciclewithbubbles")

        // Initialization code
    }
    
    
    @objc func rsvpClicked(){
        delegate?.rsvpPressed(sender: self)
    }
    
    func updateCountDown(setDate: String){
        
      //  gifView.loadGif(name: "Ciclewithbubbles")
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let formatedEndDate = releaseDateFormatter.date(from: setDate)!  as Date
        let customDate = formatedEndDate as? NSDate
        let currentDate = Date()
        let components = Set<Calendar.Component>([.day,.hour])
        let differenceOfDate = Calendar.current.dateComponents(components, from: currentDate, to: formatedEndDate)
        
        daysLeft.text = (differenceOfDate.day?.description)! + " DAYS TO GO"
        print (differenceOfDate)
        
        countdownLabel.timeFormat = "dd   HH  mm   ss"
        countdownLabel.setCountDownDate(targetDate: customDate!)
        countdownLabel.animationType = .Scale
        countdownLabel.start()
       

        
    }
    

}
