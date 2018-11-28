//
//  ProductCheckoutController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 28/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class ProductCheckoutController: UIViewController {
    
    //MARK: - Making IB Outlets
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeDislikeButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - Viewcontroller lifecycle

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        // Do any additional setup after loading the view.
    }
    

    func setup(){
        
        nextButton.roundCorners(corners: .allCorners, radius: 24)
        
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
