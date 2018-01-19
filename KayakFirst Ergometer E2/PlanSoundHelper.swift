//
//  PlanSoundHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import AVFoundation

class PlanSoundHelper {
    
    //MARK: constants
    private let soundThresholdTime: Double = 10000 // 10 s
    private let soundThresholdDistance: Double = 10 // 10 m
    
    //MARK: properties
    private var audio: AVAudioPlayer?
    private let telemetry = Telemetry.sharedInstance
    private var shouldPlayByCycle = false
    private var shouldPlay = false
    
    //MARK: init
    static let sharedInstance = PlanSoundHelper()
    
    private init() {
        initAudio()
    }
    
    //MARK: functions
    func playSoundIfNeeded(value: Double, planType: PlanType) {
        var neededPlay = false
        if PlanType.distance == planType {
            neededPlay = value <= soundThresholdDistance
        } else if PlanType.time == planType {
            neededPlay = value <= soundThresholdTime
        }
        
        neededPlay = neededPlay && value > 0
        
        startSound(neededPlay && shouldPlay && shouldPlayByCycle)
    }
    
    func onResume() {
        shouldPlay = true
    }
    
    func onPause() {
        shouldPlay = false
        startSound(false)
    }
    
    func cycleResume() {
        shouldPlayByCycle = true
    }
    
    func cyclePause() {
        shouldPlayByCycle = false
        startSound(false)
    }
    
    func cycleStop() {
        audio?.stop()
    }
    
    private func initAudio() {
        let path = Bundle.main.path(forResource: "plan_tick", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            audio = sound
            audio!.numberOfLoops = -1
        } catch {
            log("AUDIO_EXC", error)
        }
    }
    
    private func startSound(_ isStart: Bool) {
        var isPlaying = false
        
        if audio != nil {
            isPlaying = audio!.isPlaying
            
            if isStart {
                if !isPlaying {
                    audio!.play()
                }
            } else {
                if isPlaying {
                    audio!.pause()
                }
            }
        } else {
            initAudio()
        }
    }
    
}
