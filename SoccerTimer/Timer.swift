//
//  Timer.swift
//  SoccerTimer
//
//  Created by Hayden Scott on 2/13/16.
//  Copyright © 2016 Hayden Scott. All rights reserved.
//

import Foundation
import AVFoundation

class Timer {
    var runTime: Int
    var restTime: Int
    var startTime: NSTimeInterval!
    var numRuns = 0
    var working:Bool = true
    let synthesizer = AVSpeechSynthesizer()
    
    init(runTime:Int, restTime:Int){
        self.restTime = restTime
        self.runTime = runTime
    }
    
    func start() {
        let goUtter:AVSpeechUtterance = AVSpeechUtterance(string: "Go")
        goUtter.voice = AVSpeechSynthesisVoice(language: "en-GB")
        synthesizer.speakUtterance(goUtter)
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    func countDown() {
        startTime = NSDate.timeIntervalSinceReferenceDate() + Double(restTime)
    }
    
    func stop() {
    }
    
    func clear() {
        startTime = 0
    }
    
    func getTimeElapsed()-> Int {
        return Int(NSDate.timeIntervalSinceReferenceDate() - startTime)
    }
    
    func getCurrentSecond() -> Int {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime:NSTimeInterval = currentTime - startTime
        elapsedTime -= (NSTimeInterval(Int(elapsedTime / 60.0)) * 60)
        let currentSecond:Int = Int(elapsedTime)
        return currentSecond
    }
    
    func getRunTime() -> Int {
        return self.runTime
    }
    
    func getRestTime() -> Int {
        return self.restTime
    }
    
    func updateTime() -> String {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime:NSTimeInterval = 0
        elapsedTime = currentTime - startTime
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        let milli = UInt8(elapsedTime * 100)
        let minStr = minutes > 9 ? String(minutes):"0" + String(minutes)
        let secStr = seconds > 9 ? String(seconds):"0" + String(seconds)
        let milliStr = milli > 9 ? String(milli):"0" + String(milli)
        return "\(minStr):\(secStr):\(milliStr)"
    }
}