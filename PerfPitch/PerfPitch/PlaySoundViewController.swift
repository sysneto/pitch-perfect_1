//
//  PlaySoundViewController.swift
//  PerfPitch
//
//  Created by Kadar Toth Istvan on 17/03/15.
//  Copyright (c) 2015 Kadar Toth Istvan. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundViewController: UIViewController {
    // Settings
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        //init the audioPlayer
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate=true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //---------Audio function Section------
    func playAudioWithRate(x:Float){
        //plays an audio file with render options
        stopPlayerandEngine()
        audioPlayer.rate=x
        audioPlayer.play()
    }
    func stopPlayerandEngine(){
        //Stop audioPlayer and audioEngine
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
    }
    func playAudioWithEffect(effect: String, pitch: Float){
        //audion effects function in engine for output
        var effectObj = NSObject()
        var audioPlayerNode = AVAudioPlayerNode()
        
        switch(effect)
        {
        case "echo":
            var echoSound = AVAudioUnitDelay()
            echoSound.delayTime = NSTimeInterval(0.3)
            effectObj = echoSound as NSObject
        case "pitch":
            var pitchSound = AVAudioUnitTimePitch()
            pitchSound.pitch = pitch
            effectObj = pitchSound as NSObject
        case "reverb":
            var reverbSound = AVAudioUnitReverb()
            reverbSound.loadFactoryPreset(.LargeRoom2)
            reverbSound.wetDryMix = 75
            effectObj = reverbSound as NSObject
        default:
            break
        }
        //stop current plays
        stopPlayerandEngine()
        //add effect to engine
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effectObj as AVAudioNode)
        audioEngine.connect(audioPlayerNode, to: effectObj as AVAudioNode, format: nil)
        audioEngine.connect(effectObj as AVAudioNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        //play the pitch sound
        audioPlayerNode.play()
    }
    // -----------Button Actions--------------
    @IBAction func slow(sender: AnyObject) {
        //play the recorded sound with low pich level
        playAudioWithRate(0.5)
    }
    @IBAction func playFastAudio(sender: AnyObject) {
        //plays the recorded sound with low pitch level
        playAudioWithRate(1.5)
    }

    @IBAction func stopAudio(sender: AnyObject) {
        //stop the sound play
        stopPlayerandEngine()
    }
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        //plays recorded sound with chipmunk effect: effect name, pitch amount
        playAudioWithEffect("pitch", pitch: 1000)
    }
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        //plays recorded sound with chipmunk darthvader effect:  effect name, pitch amount
        playAudioWithEffect("pitch", pitch: -900)
    }
    @IBAction func playEchoAudio(sender: UIButton) {
        //plays recorded sound with echo effect: effect name, pitch amount
        playAudioWithEffect("echo", pitch: 0)
    }
    @IBAction func playReverbAudion(sender: UIButton) {
        //plays recorded sound with reverb effect:effect name, pitch amount
        playAudioWithEffect("reverb", pitch: 0)
    }

}
