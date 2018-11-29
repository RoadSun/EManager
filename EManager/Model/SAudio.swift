//
//  SSound.swift
//  DSRobotEditorPad
//
//  Created by EX DOLL on 2018/11/23.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit
import AVFoundation
class SAudio: NSObject {
    static let shared = SAudio()
    lazy var player:AVPlayer = {
        let player = AVPlayer()
        player.volume = 1
        return player
    }()
    
    var duration:TimeInterval!
    var currentTime:TimeInterval!
    var isloop = false
    var list = [URL]()
    
    public func loadFile(_ path:String) {
        let item = AVPlayerItem(url: URL(fileURLWithPath: path))
        player.replaceCurrentItem(with: item)
        player.play()
    }
    
    public func start() {
        if player.rate == 1{
            pause()
        }else{
            player.play()
        }
    }
    
    func pause() {
        player.pause()
    }
    
    func stop() {
        
    }
    
    func volume(_ volume:Float) {
        player.volume = volume
    }
    
}
