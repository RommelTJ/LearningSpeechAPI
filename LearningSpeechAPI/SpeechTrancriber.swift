//
//  SpeechTrancriber.swift
//  LearningSpeechAPI
//
//  Created by Rommel Rico on 10/30/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

import Speech

class SpeechTrancriber {
    
    init() {
        SFSpeechRecognizer.requestAuthorization() {
            status in
            if status == .authorized {
                print("We're good to go!")
            }
            else {
                fatalError("Sorry, this demo is a bit pointless if you disable dictation")
            }
        }
    }
    
}
