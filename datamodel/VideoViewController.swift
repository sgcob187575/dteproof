//
//  VideoViewController.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/15.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SwiftUI
class VideoView: UIView {

    
    
    private var playerItemContext = 0
    private var player: AVQueuePlayer? {
        get {
            return playerLayer.player as? AVQueuePlayer
        }
        set {
            playerLayer.player = newValue
        }
    }
    private var looper:AVPlayerLooper?
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    func play(with url: URL) {
        initPlayerAsset(with: url) { (asset: AVAsset) in
            let item = AVPlayerItem(asset: asset)
            item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &self.playerItemContext)
            DispatchQueue.main.async {

            self.player = AVQueuePlayer(playerItem: item)
            self.looper = AVPlayerLooper(player: self.player!, templateItem: item)
                self.player?.play()

                             
            }
            
        }
    }
    
    private func initPlayerAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        let asset = AVAsset(url: url)
        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            completion?(asset)
        }
    }

   

}
struct VideoviewController:UIViewRepresentable {
    var urlstring:String
    func makeUIView(context: Context) -> VideoView {
        let videoView = VideoView()
        if let url = URL(string:urlstring) {
            videoView.play(with: url)
        }
        return videoView
    }
    
    func updateUIView(_ uiView: VideoView, context: Context) {
        
    }
    
    typealias UIViewType = VideoView
    }
