//
//  SectionHeader.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 10/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    
    var timeEnd : Date?
    
    var setDate = String(){
        didSet{
            updateUI()
        }
    }
    

    @IBOutlet weak var seatsLeft: UILabel!
    @IBOutlet weak var outerView: UIView!
     var headerView : HeaderView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
   
         timeEnd = Date(timeInterval: "2019-01-01 10:00:00".toDate(format: "yyyy-MM-dd HH:mm:ss").timeIntervalSince(Date()), since: Date())
        
        
        headerView = HeaderView(frame: CGRect(x:0, y: 0,width : self.outerView.frame.width, height : 114))
        
        self.outerView.addSubview(headerView!)
        
//        headerView?.roundCorners(corners: .allCorners, radius: 24)
        updateView()
       
        // Initialization code
    }
    
    
    func updateView() {
        // Initialize the label
        
        setTimeLeft()
        
        // Start timer
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setTimeLeft), userInfo: nil, repeats: true)
    }
    
    func updateUI(){
        
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
            timeEnd = releaseDateFormatter.date(from: setDate)!  as Date
        
        setTimeLeft()
        
    }
    
    @objc func setTimeLeft() {
        let timeNow = Date()
        
        
        if timeEnd?.compare(timeNow) == ComparisonResult.orderedDescending {
            
            let interval = timeEnd?.timeIntervalSince(timeNow)
            
            let days =  (interval! / (60*60*24)).rounded(.down)
            
            let daysRemainder = interval?.truncatingRemainder(dividingBy: 60*60*24)
            
            let hours = (daysRemainder! / (60 * 60)).rounded(.down)
            
            let hoursRemainder = daysRemainder?.truncatingRemainder(dividingBy: 60 * 60).rounded(.down)
            
            let minites  = (hoursRemainder! / 60).rounded(.down)
            
            let minitesRemainder = hoursRemainder?.truncatingRemainder(dividingBy: 60).rounded(.down)
            
            let scondes = minitesRemainder?.truncatingRemainder(dividingBy: 60).rounded(.down)
            
            
            headerView?.DaysProgress.setProgress(days/360, animated: false)
            headerView?.hoursProgress.setProgress(hours/24, animated: false)
            headerView?.minitesProgress.setProgress(minites/60, animated: false)
            headerView?.secondesProgress.setProgress(scondes!/60, animated: false)
            
            let formatter = NumberFormatter()
            formatter.minimumIntegerDigits = 2
            
            headerView?.valueDay.text = formatter.string(from: NSNumber(value:days))
            headerView?.valueHour.text = formatter.string(from: NSNumber(value:hours))
            headerView?.valueMinites.text = formatter.string(from: NSNumber(value:minites))
            headerView?.valueSeconds.text = formatter.string(from: NSNumber(value:scondes!))
            
            
            
        } else {
            headerView?.fadeOut()
        }
    }
    
    func updateSeats(count: Int){
        
        seatsLeft.text = "SEATS LEFT: " + count.description
        
        
    }
    
}
