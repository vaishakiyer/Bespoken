//
//  BagViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 13/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import AlamofireImage

class BagViewController: UIViewController {

    @IBOutlet weak var innerView1: UIView!
    @IBOutlet weak var innerView2: UIView!
    @IBOutlet weak var innerView3: UIView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var productDemo: UIButton!
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var priceTag: UILabel!
    @IBOutlet weak var checkOutPrice: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        innerView1.dropShadow(color: .darkGray, offSet: .zero)
         innerView2.dropShadow(color: .darkGray, offSet: .zero)
         innerView3.dropShadow(color: .darkGray, offSet: .zero)
         checkoutButton.roundCorners(corners: .allCorners, radius: 16)
         updateUI()
        // Do any additional setup after loading the view.
    }
    
    
    func updateUI(){
        
        if let url = URL(string: (currentProduct?.images.first)!){
            productImage.af_setImage(withURL: url)
        }
        
        titleLabel.text = currentProduct?.title
        numberOfLikes.text = currentProduct?.likes?.description
        priceTag.text =  (currentProduct?.currency)!  +  " " + (currentProduct?.cost.description)!
        checkOutPrice.text = (currentProduct?.currency)!  +  " " + (currentProduct?.cost.description)!
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
