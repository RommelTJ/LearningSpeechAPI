//
//  SpeechTranscriber.swift
//  LearningSpeechAPI
//
//  Created by Rommel Rico on 10/30/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

import Speech

class SpeechTranscriber {
    
    private let speechRecognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    
    /// Whether we are currently listening for audio input.
    private(set) var isTranscribing: Bool = false
    
    /// Closure executed when the recording finished and the speech recognizer was able to transcribe it.
    var onTranscriptionCompletion: ((String) -> ())?
    
    /// The current request to transcribe audio data into a string
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
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
    
    func start() {
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        do {
            try createAudioSession(onNewBufferReceived: { (buffer) in
                recognitionRequest.append(buffer)
            })
        } catch {
            fatalError("Error setting up microphone input listener!")
        }
        
        speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            guard let result = result else {
                print(String(describing: error?.localizedDescription))
                return
            }
            
            // Wait until we have the final result before calling our completion block.
            if result.isFinal {
                self.onTranscriptionCompletion?(result.bestTranscription.formattedString)
            }
        })
        
        // Store request for later use.
        self.recognitionRequest = recognitionRequest
        isTranscribing = true
    }
    
    func stop() {
        recognitionRequest?.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        isTranscribing = false
    }
    
    
    /// Sets up the audio session.
    private func createAudioSession(onNewBufferReceived: @escaping (AVAudioPCMBuffer) -> ()) throws {
        let audioSession = AVAudioSession.sharedInstance()
        
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            onNewBufferReceived(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
    }
    
}
