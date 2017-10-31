//
//  ViewController.swift
//  LearningSpeechAPI
//
//  Created by Rommel Rico on 10/30/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Instruction: String {
        case left
        case right
        case up
        case down
    }

    let transcriber = SpeechTranscriber()
    let ninja = UIImageView(image: #imageLiteral(resourceName: "Ninja"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func directionsButtonPressed(_ sender: UIButton) {
        if !transcriber.isTranscribing {
            // Not currently listening for directions, so let's start!
            transcriber.start()
            // Update button appearance
            sender.setTitle("End Recording", for: .normal)
            sender.backgroundColor = .red
        } else {
            // Already listening, so let's stop the recording
            transcriber.stop()
            // Update button appearance
            sender.setTitle("Record Directions", for: .normal)
            sender.backgroundColor = .green
        }
    }
    
}

