//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Egorio on 1/15/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        resetRecorderScreenState()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }
    
    func resetRecorderScreenState() {
        stopButton.hidden = true
        pauseButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.text = "Tap to record your voice"
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(recorder: recorder)
            
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            resetRecorderScreenState()
            
            recordingInProgress.text = "Something wrong, try to Record again"
        }
    }
    
    @IBAction func startRecordingAudio(sender: UIButton) {
        recordingInProgress.text = "Recording..."
        recordButton.enabled = false
        pauseButton.hidden = false
        pauseButton.enabled = true
        stopButton.hidden = false
        
        let session = AVAudioSession.sharedInstance()
        
        if session.category != AVAudioSessionCategoryPlayAndRecord {
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
            let recordingName = "record.wav"
            let filePath = NSURL.fileURLWithPathComponents([dirPath, recordingName])
            
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        
        audioRecorder.record()
    }
    
    @IBAction func pauseRecordingAudio(sender: UIButton) {
        recordingInProgress.text = "Tap to continue recording"
        pauseButton.enabled = false
        recordButton.enabled = true
        
        audioRecorder.pause()
    }
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        pauseButton.hidden = true
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}
