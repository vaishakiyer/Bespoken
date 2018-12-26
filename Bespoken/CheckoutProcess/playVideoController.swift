//
//  playVideoController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 26/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import AlamofireImage
import SwiftVideoBackground

class playVideoController: UIViewController {
    
    @IBOutlet weak var backgroundImg: UIImageView!
    
    @IBOutlet weak var videoBackground: UIView!
    
    let videoPlay = VideoBackground()
    
    var imageUrl : String?
    var videoUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNav()
        updateVideoAndImage()
        // Do any additional setup after loading the view.
    }
    
    func createNav(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateVideoAndImage(){
        
        if let imgUrl = URL(string: imageUrl!){
            
            backgroundImg.af_setImage(withURL: imgUrl)
        }
        
        if let vidUrl = URL(string: videoUrl!){
            videoPlay.play(view: videoBackground, url: vidUrl)
        }
        
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
