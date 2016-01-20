//
//  RecorderAudio.swift
//  Pitch Perfect
//
//  Created by Egorio on 1/19/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import Foundation
import AVFoundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(recorder: AVAudioRecorder) {
        title = recorder.url.lastPathComponent
        filePathUrl = recorder.url
    }
}
