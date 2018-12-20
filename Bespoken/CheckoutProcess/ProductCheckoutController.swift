//
//  ProductCheckoutController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 28/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
class ProductCheckoutController: UIViewController {
    
    //MARK: - Making IB Outlets
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeDislikeButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var theProduct : Product?
    var theProductId : String?
    
    //MARK: - Viewcontroller lifecycle

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        // Do any additional setup after loading the view.
    }
    

    func setup(){
        
        nextButton.roundCorners(corners: .allCorners, radius: 24)
        nextButton.addTarget(self, action: #selector(goToMeasurement), for: .touchUpInside)
        createNav()
        updateUI()
        //getProductAPI(id : self.theProductId!)
    }
    
    func createNav(){
        
        self.navigationItem.title = "PRODUCT BAG"
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissController))
    }
    
   @objc func dismissController(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func goToMeasurement(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "MeasurementViewController") as? MeasurementViewController
        self.navigationController?.pushViewController(nextVC!, animated: true)
        
    }
    
    func updateUI(){
        
        if let url = URL(string: (theProduct?.images.first)!){
             productImage.af_setImage(withURL: url)
        }
       
        productDesc.text = theProduct?.description
        productPrice.text = (theProduct?.currency)! + " " + (theProduct?.cost.description)!
        
    }
    func getProductAPI(id : String){
        Alamofire.request(Router.getProductBy(id: id)).responseJSON(completionHandler: {
            response in
            switch response.result{
            case .success(let JSON):
                let newProduct : Product = Product(json : JSON as! JSON)
                self.theProduct = newProduct
            case .failure(let error):
                print(error.localizedDescription)
                
                
            }
        })
    }
}
