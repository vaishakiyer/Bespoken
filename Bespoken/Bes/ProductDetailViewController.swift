//
//  ProductDetailViewController.swift
//  Bespoken
//
//  Created by Mohan on 15/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import AVKit
import AVFoundation

class ProductDetailViewController: UIViewController {

    @IBOutlet var loaderView: UIView!
    @IBOutlet var btitle: UILabel!
    @IBOutlet var bdescription: UILabel!
    @IBOutlet var videoView: UIView!
    var videoPlay = VideoBackground()
    var product : Product?
    var loadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    
    func updateUI() {
        playVideo()
        btitle.text = product!.title
        bdescription.text = product!.description
        loadingIndicator.startAnimating()
        loaderView.addSubview(loadingIndicator)
        self.navigationItem.leftBarButtonItem =   UIBarButtonItem(image: UIImage(named: "BackMotif_white"), style: .done, target: self, action: #selector(dismissController))
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func dismissController(){
        self.navigationController?.popViewController(animated: true)
    }

    func playVideo(){
        print(product!.styletip!.video)
//        let videoURL : URL = URL(string: (product!.styletip!.video!))!
        
        videoPlay.isMuted = false
        videoPlay.willLoopVideo = true
        try? videoPlay.play(view: videoView, url: (product!.styletip?.localVideoURL!)! )
    }
}
