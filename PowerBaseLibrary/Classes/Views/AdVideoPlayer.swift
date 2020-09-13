//
//  AdVideoPlayer.swift
//  BaiHe
//
//  Created by 邹程 on 16/1/18.
//  Copyright © 2016年 itotemstudio. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

@objc public protocol VideoPlayDelegate: NSObjectProtocol {
    func videoPlaybackFinished()
    func videoReplay()
    @objc optional func skipVideo()
}

open class AdVideoPlayer: NSObject {
    
    fileprivate var view: UIView!
    fileprivate var videoControlView: UIView!
    fileprivate var videoView: UIView!
    
    fileprivate var soundBtn: UIButton!
    fileprivate var replayBtn: UIButton!
    fileprivate var skipBtn: UIButton!
    
    fileprivate var playerLayer: AVPlayerLayer!
    fileprivate var player: AVPlayer!
    fileprivate var playerItem: AVPlayerItem!
    
    fileprivate var soundImage: UIImage!
    fileprivate var muteImage: UIImage!
    fileprivate var videoReplayImage: UIImage!
    fileprivate var videoSkipImage: UIImage!
    
    fileprivate var mute: Bool!
    
    var videoPlaying: Bool!
    var videoPlaybackFinished: Bool!
    
    weak var delegate: VideoPlayDelegate?
    
    required public override init() {
        super.init()
        
        self.initUI(false)
        self.initVideo()
        self.initNotification()
    }
    
    public init(skipVideo: Bool) {
        super.init()
        
        self.initUI(skipVideo)
        self.initVideo()
        self.initNotification()
    }
    
    deinit {
        player?.pause()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - initUI
    fileprivate func initUI(_ skipVideo: Bool) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        soundImage = UIImage(named: "btn_video_sound")
        muteImage = UIImage(named: "btn_video_mute")
        videoReplayImage = UIImage(named: "btn_video_replay")
        videoSkipImage = UIImage(named: "btn_video_skip")
        
        view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight))
        view.backgroundColor = UIColor.clear
        
        videoView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight))
        videoView.backgroundColor = UIColor.clear
        
        videoControlView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 60.0))
        videoControlView.backgroundColor = UIColor.clear
        
        soundBtn = UIButton(type: UIButton.ButtonType.custom)
        soundBtn.frame = CGRect(x: 10.0, y: 20.0, width: 40.0, height: 40.0)
        soundBtn.setImage(soundImage, for: UIControl.State())
        soundBtn.addTarget(self, action: #selector(muteAction(_:)), for: UIControl.Event.touchUpInside)
        videoControlView.addSubview(soundBtn)
        
        if (skipVideo == false) {
            replayBtn = UIButton(type: UIButton.ButtonType.custom)
            replayBtn.frame = CGRect(x: screenWidth - 65.0, y: 20.0, width: 50.0, height: 40.0)
            replayBtn.setImage(videoReplayImage, for: UIControl.State())
            replayBtn.addTarget(self, action: #selector(replayAction(_:)), for: UIControl.Event.touchUpInside)
            videoControlView.addSubview(replayBtn)

            replayBtn.isEnabled = false
            replayBtn.alpha = 0.0
        }
        else {
            skipBtn = UIButton(type: UIButton.ButtonType.custom)
            skipBtn.frame = CGRect(x: screenWidth - 65.0, y: 20.0, width: 50.0, height: 40.0)
            skipBtn.setImage(videoSkipImage, for: UIControl.State())
            skipBtn.addTarget(self, action: #selector(skipAction(_:)), for: UIControl.Event.touchUpInside)
            videoControlView.addSubview(skipBtn)
        }
    
        videoView.isHidden = false
        
        mute = false
        videoPlaying = false
        videoPlaybackFinished = false
    }
    
    // MARK: - initVideo
    fileprivate func initVideo() {
        let filePath = Bundle.main.path(forResource: "wmc", ofType: "mp4")
        let sourceMovieURL = URL(fileURLWithPath: filePath!)
        let movieAsset = AVURLAsset(url: sourceMovieURL, options: nil)
        
        playerItem = AVPlayerItem(asset: movieAsset)
        
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        videoView.layer.addSublayer(playerLayer)
        view.addSubview(videoView)
        view.addSubview(videoControlView)
        self.monitoringPlayback()
    }
    
    // MARK: - initNotification
    fileprivate func initNotification() {
        _ = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: "applicationDidBecomeActive:", name: kApplicationDidBecomeActiveNotification, object: nil)
//        notificationCenter.addObserver(self, selector: "applicationDidEnterBackground:", name: kApplicationDidEnterBackgroundNotification, object: nil)
//        notificationCenter.addObserver(self, selector: "playbackFinished", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
//        notificationCenter.addObserver(self, selector: "manualLoginSuccessful:", name: MANUAL_LOGIN_SUCCESSFUL_NOTIFICATION, object: nil)
//        notificationCenter.addObserver(self, selector: "manualThirdPartyLoginSuccessful:", name: MANUAL_THIRDPARTY_LOGIN_SUCCESSFUL_NOTIFICATION, object: nil)
    }
    
    // MARK: - monitoringPlayback
    fileprivate func monitoringPlayback() {
        player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil) { [weak self] (time: CMTime) -> Void in
            if let strongSelf = self {
                let currentSecond = Double(strongSelf.playerItem.currentTime().value) / Double(strongSelf.playerItem.currentTime().timescale)
//                print("\n", currentSecond)
                
                if currentSecond >= 11 && strongSelf.videoView.alpha == 1.0 {
                    strongSelf.videoProcess()
                }
                
//                let totalSecond = CMTimeGetSeconds(strongSelf.playerItem.duration)
//                print("\n Video Seconds", totalSecond)
//                
//                if currentSecond >= totalSecond {
//                    
//                }
            }
        }
    }
    
    fileprivate func videoProcess() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.videoView.alpha = 0.0
                strongSelf.delegate?.videoPlaybackFinished()
            }
        }, completion: { (Bool) -> Void in
                
        })
    }
    
    // MARK: - notifications
    func applicationDidBecomeActive(_ notification: Notification) {
        if videoPlaying == true {
            if (player?.status == AVPlayer.Status.readyToPlay) {
                player?.play()
                dPrint("\n applicationDidBecomeActive play \n")
            }
        }
    }
    
    func applicationDidEnterBackground(_ notification: Notification) {
        player?.pause()
        dPrint("\n applicationDidEnterBackground payse \n")
    }
    
    func playbackFinished() {
        replayBtn?.isEnabled = true
        skipBtn?.isEnabled = false
        skipBtn?.isHidden = true
        videoPlaying = false
        videoPlaybackFinished = true
        UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.replayBtn?.alpha = 1.0
                strongSelf.videoView.alpha = 0.0
                strongSelf.delegate?.videoPlaybackFinished()
            }
        }, completion: { (Bool) -> Void in

        })
    }
    
    func manualLoginSuccessful(_ notification: Notification) {
        videoPlaying = false
        videoPlaybackFinished = true
        player?.pause()
    }
    
    func manualThirdPartyLoginSuccessful(_ notification: Notification) {
        self.manualLoginSuccessful(notification)
    }

    // MARK: - actions
    @IBAction func muteAction(_ sender: AnyObject) {
        if mute == true {
            soundBtn.setImage(soundImage, for: UIControl.State())
        }
        else {
            soundBtn.setImage(muteImage, for: UIControl.State())
        }
        
        mute = !mute
        player?.isMuted = mute
    }
    
    @IBAction func replayAction(_ sender: AnyObject) {
        delegate?.videoReplay()
        
        replayBtn?.isEnabled = false
        
        videoView.alpha = 1.0
        replayBtn?.alpha = 0.0
        
        player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        player?.play()
        
        videoPlaying = true
        videoPlaybackFinished = false
    }
    
    @IBAction func skipAction(_ sender: AnyObject) {
        skipBtn?.isEnabled = false
        skipBtn?.isHidden = true
        videoPlaying = false
        videoPlaybackFinished = true
        player?.pause()
        delegate?.skipVideo!()
    }
    
    // MARK: - (public) videoPlayView
    func videoPlayView() -> UIView {
        return view
    }
    
    // MARK: - (public) play
    func play() {
        player?.play()
        videoPlaying = true
    }
    
    // MARK: - (public) pause
    func pause () {
        player?.pause()
        videoPlaying = false
    }
}
