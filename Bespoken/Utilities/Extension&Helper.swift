//
//  File.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 18/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import Foundation
import UIKit

class Helper{
    
    class func dropShadowOnTableView(table: UITableView){
        
        table.layer.masksToBounds = false
        table.layer.shadowColor = UIColor.darkGray.cgColor
        table.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        table.layer.shadowOpacity = 0.5
        table.layer.shadowRadius = 6
        
    }
    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
    
    
    
    

