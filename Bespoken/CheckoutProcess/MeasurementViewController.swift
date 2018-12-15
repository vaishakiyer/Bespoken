//
//  ProductBagViewController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 27/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class MeasurementViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var measTypeCollection: UICollectionView!
    
    @IBOutlet weak var customiseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    //MARK: - Viewcontroller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setup()
        
        // Do any additional setup after loading the view.
    }
    

    func setup(){
        
     measTypeCollection.delegate = self
     measTypeCollection.dataSource = self
     measTypeCollection.register(UINib(nibName: "sizeChartCell", bundle: nil), forCellWithReuseIdentifier: "sizeChartCell")
    customiseButton.roundCorners(corners: .allCorners, radius: 24)
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

extension MeasurementViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell =  measTypeCollection.dequeueReusableCell(withReuseIdentifier: "sizeChartCell", for: indexPath) as? sizeChartCell
        
        
        return cell!
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 148, height: 127)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
    }
    
    
    
}
