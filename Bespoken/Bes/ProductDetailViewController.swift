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

    @IBOutlet var btitle: UILabel!
    @IBOutlet var bdescription: UILabel!
    @IBOutlet var videoView: UIView!
    var product : Product?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateUI()

    }
    
    func updateUI() {
        playVideo()
        btitle.text = product!.title
        bdescription.text = product!.description
    }

    func playVideo(){
        print(product!.styletip?.video!)
//        videoPlay.play(view: videoView, url: URL(string: (product!.styletip["video"]!))!)
        var videoPlay = AVPlayer(url: URL(string: ((product!.styletip?.video!)!))!)
        let playerLayer = AVPlayerLayer(player: videoPlay)
        playerLayer.frame = self.videoView.bounds
        self.videoView.layer.addSublayer(playerLayer)
        videoPlay.play()
//        BSLoader.showLoading()
//        videoPlay.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 600), queue: DispatchQueue.main, using: { time in
//            
//            if videoPlay.currentItem?.status == AVPlayerItem.Status.readyToPlay {
////                BSLoader.hide()
//
//                if let isPlaybackLikelyToKeepUp = videoPlay.currentItem?.isPlaybackLikelyToKeepUp {
//                    //do what ever you want with isPlaybackLikelyToKeepUp value, for example, show or hide a activity indicator.
//                    //MBProgressHUD.hide(for: self.view, animated: true)
//                }
//            }
//        })

//        videoPlay.playImmediately(atRate: 0.50)
//        videoPlay.play(view: videoView, url: URL(string: (product!.styletip["video"]!))!, darkness: 0, isMuted: false, willLoopVideo: true, setAudioSessionAmbient: true)
    }
}
