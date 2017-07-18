//
//  PlanSoundHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import AVFoundation

//TODO: not always play the sound (if there is more planElements)
class PlanSoundHelper: CycleStateChangeListener {
    
    //MARK: constants
    private let soundThresholdTime: Double = 10000 // 10 s
    private let soundThresholdDistance: Double = 10 // 10 m
    
    //MARK: properties
    private var audio: AVAudioPlayer?
    private let telemetry = Telemetry.sharedInstance
    private var shouldPlayByCycle = false
    var shouldPlay = false
    
    //MARK: init
    static let sharedInstance = PlanSoundHelper()
    
    private init() {
        telemetry.addCycleStateChangeListener(cycleStateChangeListener: self)
    }
    
    func stopSound() {
        startSound(false)
    }

    func playSoundIfNeeded(value: Double, planType: PlanType) {
        var neededPlay = false
        if PlanType.distance == planType {
            neededPlay = value <= soundThresholdDistance
        } else if PlanType.time == planType {
            neededPlay = value <= soundThresholdTime
        }
        
        startSound(neededPlay && shouldPlay && shouldPlayByCycle)
    }
    
    private func startSound(_ isStart: Bool) {
        var isPlaying = false
        
        isPlaying = audio != nil && audio!.isPlaying
        
        if isStart {
            if !isPlaying {
                let path = Bundle.main.path(forResource: "plan_tick", ofType: "mp3")!
                let url = URL(fileURLWithPath: path)
                do {
                    let sound = try AVAudioPlayer(contentsOf: url)
                    audio = sound
                    sound.numberOfLoops = -1
                    sound.play()
                } catch {
                    log("AUDIO_EXC", error)
                }
            }
        } else {
            if isPlaying {
                audio?.stop()
            }
        }
    }
    
    func onCycleStateChanged(newCycleState: CycleState) {
        shouldPlayByCycle = CycleState.resumed == newCycleState
    }
}
