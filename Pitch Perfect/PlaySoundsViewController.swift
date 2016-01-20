//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Egorio on 1/18/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        try! audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    func stopPlaying() {
        audioEngine.stop()
        audioPlayer.stop()
        audioEngine.reset()
    }
    
    func playWithRate(rate: Float) {
        stopPlaying()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playWithEffect(effect: AVAudioUnit) {
        stopPlaying()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()

    }
    
    func playWithPitch(pitch: Float) {
        let effect = AVAudioUnitTimePitch()
        effect.pitch = pitch
       
        playWithEffect(effect)
    }
    
    func playWithReverb() {
        let effect = AVAudioUnitReverb()
        
        playWithEffect(effect)
    }
    
    func playWithEcho() {
        let effect = AVAudioUnitDelay()
        effect.delayTime = 0.5
        effect.feedback = 30
        
        playWithEffect(effect)
    }
    
    @IBAction func playSlow(sender: UIButton) {
        playWithRate(0.5)
    }

    @IBAction func playFast(sender: UIButton) {
        playWithRate(1.5)
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        playWithPitch(1000)
    }
    
    @IBAction func playDarth(sender: UIButton) {
        playWithPitch(-1000)
    }
    
    @IBAction func playEcho(sender: UIButton) {
        playWithEcho()
    }
    
    @IBAction func playReverb(sender: UIButton) {
        playWithReverb()
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        stopPlaying()
    }
}
