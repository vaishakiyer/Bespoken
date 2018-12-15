//
//  ProductDetailViewController.swift
//  Bespoken
//
//  Created by Mohan on 15/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class ProductDetailViewController: UIViewController {

    @IBOutlet var btitle: UILabel!
    @IBOutlet var bdescription: UILabel!
    @IBOutlet var videoView: UIView!
    var product : Product?{
        didSet{
            self.updateUI()
        }
    }
    var videoPlay = VideoBackground()
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        btitle.text = product!.title
        bdescription.text = product!.description
    }
    
    func updateUI() {
//        playVideo()
       
    }

    func playVideo(){
//        videoPlay.play(view: videoView, url: URL(string: (product!.styletip["video"]!))!)
        videoPlay.play(view: videoView, url: URL(string: (product!.styletip["video"]!))!, darkness: 0, isMuted: true, willLoopVideo: true, setAudioSessionAmbient: true)
    }
}
