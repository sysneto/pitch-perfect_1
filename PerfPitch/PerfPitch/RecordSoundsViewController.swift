//
//  RecordSoundsViewController.swift
//  PerfPitch
//
//  Created by Kadar Toth Istvan on 17/03/15.
//  Copyright (c) 2015 Kadar Toth Istvan. All rights reserved.
//

import UIKit
import AVFoundation

var audioRecorder:AVAudioRecorder!
var recordedAudio:RecordedAudio!
var pausedStatus:Bool = false


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    //settings
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startrecordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.hidden=true
        // Do any additional setup after loading the view, typically from a nib
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //---------Record Functions---------
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        // check finish of recording
        if(flag){
            //improvements with constructor
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            //move to next view, perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            println("recording was not ok")
            //set buttons visibility for new recording
            recordStatus("new")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //prepare segue: data move from RecordSoundsViewController to PlaySoundViewController
        if(segue.identifier == "stopRecording")
        {
            let playSoundVC:PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
            let data = sender as RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //set buttons visibility when view are showed
        recordStatus("new")
    }
    
    func recordStatus(iStatus:String) {
        //set buttons visibility and label text
        switch iStatus {
        case "new":
            // start new recording when view load
            recordingLabel.text = "Tap to record"
            recordingLabel.hidden = false
            startrecordButton.enabled = true
            pauseButton.hidden = true
            stopButton.hidden = true
            
        case "start":
            // start recording
            recordingLabel.text = "Recording in progress"
            startrecordButton.enabled = false
            pauseButton.hidden = false
            pauseButton.enabled = true
            stopButton.hidden = false
            stopButton.enabled = true
            
        case "pause":
            //  paused recording
            pausedStatus = true
            pauseButton.hidden = true
            recordingLabel.text = "Tap to resume"
            startrecordButton.enabled = true
            
        default:
            break
        }
    }
    
    //-----------Button Actions-----------
    @IBAction func start(sender: AnyObject) {
        //when microphone button clicked: start the record
        if(pausedStatus){//resume recording
            //setup buttons
            recordStatus("start")
            audioRecorder.record()
            
        }else{// new recording
            //get main directory
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            // create the audio file name with datetime stamp
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            //convert string from date and adding the type of audion
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            //get recorded audio file patch converted to NSURL
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            var session = AVAudioSession.sharedInstance()
            
            //set buttons on view
            recordStatus("start")
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    
    @IBAction func pauseRecord(sender: AnyObject) {
        // When pause button clicked: pause recording
        //set buttons
        recordStatus("pause")
        audioRecorder.pause()
        
    }
    
    @IBAction func stop(sender: AnyObject) {
        //when Stop button clicked: Stop recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        //close audio session
        audioSession.setActive(false, error: nil)
        //don't resume the record make a new one, reset the status
        pausedStatus = false
    }
}

