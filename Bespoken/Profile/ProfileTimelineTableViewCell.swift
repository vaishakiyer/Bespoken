//
//  ProfileTimelineTableViewCell.swift
//  Bespoken
//
//  Created by Mohan on 20/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class ProfileTimelineTableViewCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    @IBOutlet var circleView: UIView!
    @IBOutlet var topLineView: UIView!
    @IBOutlet var bottomLineView: UIView!
    
    
    var indexPath : IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(){
        self.circleView.layer.cornerRadius = self.circleView.frame.width/2
        if self.indexPath?.row == 0{
            self.topLineView.isHidden = true
        }
    }

}
