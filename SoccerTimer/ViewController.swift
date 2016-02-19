//
//  ViewController.swift
//  SoccerTimer
//
//  Created by Hayden Scott on 2/12/16.
//  Copyright © 2016 Hayden Scott. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {

    // Mark: Properties
    var timer = NSTimer()
    var countDownTimer = NSTimer()
    var counter: Int = 0
    var callout: Int = 0
    var run:Int = 0
    var rest:Int = 0
    var numRuns:Int = 1
    var cycles:Int = 0
    var working:Bool = true
    var speak:Bool = true
    let synthesizer = AVSpeechSynthesizer()
    let AVAudioSessionCategoryAmbient: String = "True"
    @IBOutlet weak var countingLabel: UILabel!
    @IBOutlet weak var intervalField: UITextField!
    @IBOutlet weak var runField: UITextField!
    @IBOutlet weak var restField: UITextField!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var conesButton: UIButton!
    @IBOutlet weak var ffButton: UIButton!
    @IBOutlet weak var onetwoButton: UIButton!
    @IBOutlet weak var cycleField: UITextField!
    @IBOutlet weak var currentCycle: UITextField!
    var bgColor:UIColor = UIColor.whiteColor()
    var alertColor:UIColor = UIColor.redColor()
    var pausedColor:UIColor = UIColor.grayColor()
    var buttonPressedColor:UIColor = UIColor.darkGrayColor()
    var normalButtonColor:UIColor = UIColor.blueColor()
    var goUtter:AVSpeechUtterance = AVSpeechUtterance(string: "Go")
    var britishVoice:AVSpeechSynthesisVoice = AVSpeechSynthesisVoice(language: "en-GB")!
    var watch:Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intervalField.delegate = self;
        self.runField.delegate = self;
        self.restField.delegate = self;
        self.threeButton.layer.cornerRadius = 10
        self.conesButton.layer.cornerRadius = 10
        self.ffButton.layer.cornerRadius = 10
        self.onetwoButton.layer.cornerRadius = 10
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(intervalField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        threeButton.backgroundColor = normalButtonColor
        conesButton.backgroundColor = normalButtonColor
        ffButton.backgroundColor = normalButtonColor
        onetwoButton.backgroundColor = normalButtonColor
        view.endEditing(true)
    }

    ///***********************  START, PAUSE, CLEAR *******************
    @IBAction func startButton(sender: AnyObject?) {
        self.view.backgroundColor = bgColor
        if (intervalField.text == "" || runField.text == "" || restField.text == "" || cycleField.text == "") {
            return
        }
        callout = Int(intervalField.text!)!
        run = Int(runField.text!)!
        rest = Int(restField.text!)!
        cycles = Int(cycleField.text!)!
        watch = Timer(runTime: run, restTime: rest)
        watch.start()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseButton(sender: UIButton) {
        timer.invalidate()
        watch.stop()
        self.view.backgroundColor = pausedColor
    }
    
    @IBAction func clearButton(sender: UIButton) {
        threeButton.backgroundColor = normalButtonColor
        conesButton.backgroundColor = normalButtonColor
        ffButton.backgroundColor = normalButtonColor
        onetwoButton.backgroundColor = normalButtonColor
        timer.invalidate()
        counter = 0
        rest = 0
        run = 0
        intervalField.text = ""
        runField.text = ""
        restField.text = ""
        cycleField.text = ""
        currentCycle.text = "0"
        countingLabel.text = "00:00:00"
        self.view.backgroundColor = bgColor
    }
    //******************************************************************
    
    //************************ Pre-Defined Workouts *********************
    @IBAction func threeButton(sender: UIButton) {
        threeButton.backgroundColor = buttonPressedColor
        conesButton.backgroundColor = normalButtonColor
        ffButton.backgroundColor = normalButtonColor
        onetwoButton.backgroundColor = normalButtonColor
        intervalField.text = "5"
        runField.text = "65"
        restField.text = "65"
        cycleField.text = "3"
    }
    
    @IBAction func conesButton(sender: UIButton) {
        threeButton.backgroundColor = normalButtonColor
        conesButton.backgroundColor = buttonPressedColor
        ffButton.backgroundColor = normalButtonColor
        onetwoButton.backgroundColor = normalButtonColor
        intervalField.text = "5"
        runField.text = "35"
        restField.text = "30"
        cycleField.text = "10"
    }
    
    @IBAction func ffButton(sender: UIButton) {
        threeButton.backgroundColor = normalButtonColor
        conesButton.backgroundColor = normalButtonColor
        ffButton.backgroundColor = buttonPressedColor
        onetwoButton.backgroundColor = normalButtonColor
        intervalField.text = "60"
        runField.text = "1200"
        restField.text = "0"
        cycleField.text = "1"
    }
    
    @IBAction func onetwoButton(sender: UIButton) {
        threeButton.backgroundColor = normalButtonColor
        conesButton.backgroundColor = normalButtonColor
        ffButton.backgroundColor = normalButtonColor
        onetwoButton.backgroundColor = buttonPressedColor
        intervalField.text = "5"
        runField.text = "18"
        restField.text = "42"
        cycleField.text = "10"
    }
    //******************************************************************
    
    func countdown() {
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCountdown"), userInfo: nil, repeats: true)
        counter = watch.getRestTime()
    }
        
    
    func updateCounter() {
        if (watch.getCurrentSecond() == 0) {
            self.view.backgroundColor = UIColor.greenColor()
        }
        else if (watch.getTimeElapsed() % callout == 0){
            if (speak) {
                let numUtter:AVSpeechUtterance = AVSpeechUtterance(string:String(watch.getCurrentSecond()))
                numUtter.voice = britishVoice
                synthesizer.speakUtterance(numUtter)
            }
            speak = false
            self.view.backgroundColor = alertColor
        }
        else if (watch.getTimeElapsed() == watch.getRunTime()){
            let stopUtter:AVSpeechUtterance = AVSpeechUtterance(string: "Stop")
            stopUtter.voice = britishVoice
            synthesizer.speakUtterance(stopUtter)
            watch.stop()
            timer.invalidate()
            if (numRuns  < cycles) {
                numRuns++
                countdown()
            }
            else {
                let doneUtter:AVSpeechUtterance = AVSpeechUtterance(string: "Good job! You're all done")
                doneUtter.voice = britishVoice
                synthesizer.speakUtterance(doneUtter)
            }
        }
        else {
            speak = true
            self.view.backgroundColor = bgColor
        }
        countingLabel.text = watch.updateTime()
        currentCycle.text = String(numRuns)
    }
    
    func updateCountdown(){
        if (counter > 0) {
            if (counter <= 5){
                let cDownUtter:AVSpeechUtterance = AVSpeechUtterance(string: String(counter))
                cDownUtter.voice = britishVoice
                synthesizer.speakUtterance(cDownUtter)
                self.view.backgroundColor = alertColor
            }
            else {
                self.view.backgroundColor = bgColor
            }
            countingLabel.text = String(counter)
            counter--
        }
        else {
            countDownTimer.invalidate()
            self.startButton(nil)
        }
    }
}

