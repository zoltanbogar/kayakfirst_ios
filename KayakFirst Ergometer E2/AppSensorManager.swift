//
//  AppSensorManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreMotion

let analyzeTime: Double = 3000

class AppSensorManager {
    
    static let maxSpm: Double = 200
    private let minSpm: Double = 24
    private let sampleRate: Double = 50 //Hz
    private let axisY = 1
    private let axisZ = 2
    private let defaultThreshold: Double = 0.25
    private let thresholdCheckUnit: Double = 0.5
    
    //MARK: properties
    private let sensorManager = CMMotionManager()
    private let operationQueue = OperationQueue()
    private let gyroQueue = DispatchQueue(label: "gyroQueue")
    
    private var arraySPM = [TimeInterval]()
    private let nRows = 3
    private var lastSPM: TimeInterval = 0
    private var accelInit = false
    private var initCycle = false
    
    private var initAccelerometerTime: TimeInterval = 0
    private var initValues = [[Double]]()
    private var angleZ: Double = 0
    private var axis: Int = 0
    
    private var gyroY: Double = 0
    private var gyroZ: Double = 0
    
    private var accelThresholdN: Double = 0
    private var accelThresholdP: Double = 0
    private var countDyn: Int = 0
    private var dynamicMed = [Double]()
    private var dynamicTime: Double = 0
    private var factorComp: Double = 0
    private var factorComp2: Double = 0
    private var initTime: Double = 0
    private var lastSpmTime: Double = 0
    private var maxAccel: Double = 0
    private var maxAtime: Double = 0
    private var minAccel: Double = 0
    private var minAtime: Double = 0
    private var negativeA = false
    private var positiveA = false
    private var removeY: Double = 0
    private var removeZ: Double = 0
    private var spms = [Double]()
    private var spmTime: Double = 0
    private var ultSPM: Double = 0
    
    private let telemetry = Telemetry.sharedInstance
    
    var strokesPerMin: Double = 0
    private var strokes: Int = 0
    private var lastStrokes: Int = 0
    
    private var movingAvgAcc = MovingAverage()
    private var movingAvgMed = MovingAverage()
    private var movingAvgGyroY = MovingAverage()
    private var movingAvgGyroZ = MovingAverage()
    
    private var lastRealStrokesTimestamp: Double = 0
    
    
    //MARK: init
    static let sharedInstance = AppSensorManager()
    private init() {
        if sensorManager.isAccelerometerAvailable {
            // ~50Hz
            sensorManager.accelerometerUpdateInterval = (1 / sampleRate)
            operationQueue.name = "accelerometer"
        }
    }
    
    func calibrate() {
        reset()
        startSensorMonitoring(start: true)
    }
    
    //MARK: start/stop
    func startSensorMonitoring(start: Bool) {
        if start {
            sensorManager.startAccelerometerUpdates(to: operationQueue, withHandler: {
                [weak self] (data: CMAccelerometerData?, error: Error?) in
                if let acceleration = data?.acceleration {
                    
                    self?.onSensorChanged(acceleration: acceleration)
                }
            })
            sensorManager.startGyroUpdates(to: operationQueue, withHandler: {
                [weak self] (data: CMGyroData?, error: Error?) in
                if let rotationRate = data?.rotationRate {
                    
                    self?.onSensorChanged(rotationRate: rotationRate)
                }
            })
        } else {
            sensorManager.stopAccelerometerUpdates()
            sensorManager.stopGyroUpdates()
            stopStuff()
        }
    }
    
    //MARK: reset
    private func reset() {
        createDynamicMed()
        
        arraySPM = [Double]()
        for _ in 0..<nRows {
            arraySPM.append(-1)
        }
        
        accelThresholdN = -defaultThreshold
        accelThresholdP = defaultThreshold
        
        strokesPerMin = 0
        initAccelerometerTime = 0
        initValues = [[Double]]()
        initCycle = false
        
        spms = [Double]()
        
        movingAvgAcc = MovingAverage(numAverage: getMovingAverageNum())
        movingAvgMed = MovingAverage(numAverage: 5)
        movingAvgGyroY = MovingAverage(numAverage: getMovingAverageNum())
        movingAvgGyroZ = MovingAverage(numAverage: getMovingAverageNum())
    }
    
    private func onSensorChanged(acceleration: CMAcceleration) {
        if !initCycle || shouldSensorRead() {
            if !initCycle {
                if initAccelerometerTime == 0 {
                    initAccelerometerTime = telemetry.getAbsoluteTimestamp()
                }
                
                if ((telemetry.getAbsoluteTimestamp() - initAccelerometerTime) < analyzeTime) {
                    initValues.append([acceleration.x * 9.81, acceleration.y * 9.81, acceleration.z * 9.81])
                }
                
                if ((telemetry.getAbsoluteTimestamp() - initAccelerometerTime) > analyzeTime) {
                    calDefault()
                    initCycle = true
                    telemetry.cycleState = CycleState.calibrated
                }
            } else {
                let time = telemetry.getAbsoluteTimestamp()
                if (time - lastSPM > getMaxTimeBetweenStrokes() && accelInit) {
                    lastSPM = time
                }
                
                defCurrentAccel(time: time, y: (acceleration.y) * 9.81 , z: (acceleration.z) * 9.81)
            }
        }
    }
    
    private func onSensorChanged(rotationRate: CMRotationRate) {
        gyroQueue.sync {
            if !initCycle || shouldSensorRead() {
                gyroY = movingAvgGyroY.calAverage(newValue: rotationRate.y)
                gyroZ = movingAvgGyroZ.calAverage(newValue: rotationRate.z)
            }
        }
    }
    
    private func calDefault() {
        var f2: Double = 0
        var f3: Double = 0
        for i in 0..<initValues.count {
            f2 += initValues[i][1]
            f3 += initValues[i][2]
        }
        let ay = f2 / Double(initValues.count)
        let az = f3 / Double(initValues.count)
        
        if abs(az) < 9.81 {
            angleZ = asin((abs(az) / 9.81))
        } else {
            angleZ = asin(1)
        }
        
        log("SPM_TEST", "angleZ: \(angleZ * 180 / Double.pi)")
        
        if (angleZ * 180 / Double.pi) < 45 {
            axis = axisZ
        } else {
            axis = axisY
        }
        removeZ = az
        removeY = ay
        
        factorComp2 = cos(angleZ)
        factorComp = cos((90 / 180 * Double.pi) - angleZ)
        
        arraySPM = [Double]()
        spms = [Double]()
        for _ in 0..<nRows {
            arraySPM.append(-1)
        }
    }
    
    private func calcSPM(timeA: TimeInterval) -> Double {
        var variavel = -1
        if arraySPM[0] == -1 {
            arraySPM[0] = timeA
            return 0
        }
        var spmTotal: Double = 0
        if arraySPM[arraySPM.count - 1] == -1 {
            for xr in 0..<arraySPM.count {
                if arraySPM[xr] == -1 {
                    variavel = xr
                    arraySPM[xr] = timeA
                    break
                }
            }
        } else {
            for xr in 0..<(arraySPM.count - 1) {
                arraySPM[xr] = arraySPM[xr + 1]
            }
            variavel = arraySPM.count - 1
            arraySPM[arraySPM.count - 1] = timeA
        }
        if arraySPM.count >= 2 {
            var index = 0
            if variavel > 0 {
                index = variavel
            } else {
                index = arraySPM.count - 1
            }
            
            spmTotal = Double((index * 60)) / (((arraySPM[index] - arraySPM[0]))/1000)
        }
        if spmTotal > AppSensorManager.maxSpm {
            spmTotal = AppSensorManager.maxSpm
        }
        
        return spmTotal
    }
    
    private func defCurrentAccel(time: Double, y: Double, z: Double) {
        var accelValue: Double = 0
        if axis == axisZ {
            accelValue = ((z - removeZ) * factorComp2)
        } else {
            accelValue = ((y - removeY) * factorComp)
        }
        defAccelState(time: time, val: movingAvgAcc.calAverage(newValue: accelValue), realVal: accelValue)
    }
    
    private func defAccelState(time: Double, val: Double, realVal: Double) {
        if dynamicTime > 0 {
            if ((telemetry.getAbsoluteTimestamp() - dynamicTime) > getMaxTimeBetweenStrokes()) {
                if countDyn > (dynamicMed.count - 1) {
                    countDyn = 0
                }
                dynamicMed[countDyn] = 0
                countDyn += 1
                var sum: Double = 0
                for x in 0..<dynamicMed.count {
                    sum += dynamicMed[x]
                }
                
                var med = movingAvgMed.calAverage(newValue: sum / Double(dynamicMed.count))
                
                if 0.5 * med > 0.2 {
                    med = movingAvgMed.calAverage(newValue: 0.4)
                }
                
                accelThresholdN = -thresholdCheckUnit * med
                accelThresholdP = thresholdCheckUnit * med
                
                dynamicTime = telemetry.getAbsoluteTimestamp()
            }
        }
        
        if !accelInit {
            if val > accelThresholdP {
                maxAccel = val
                maxAtime = time
                positiveA = true
                negativeA = false
            } else if val < accelThresholdN {
                minAccel = val
                minAtime = time
                positiveA = false
                negativeA = true
            }
            accelInit = true
        } else if val > accelThresholdP {
            if maxAccel < val {
                positiveA = true
                maxAccel = val
                maxAtime = time
            }
        } else if val < accelThresholdN {
            if positiveA && minAccel < defaultThreshold && maxAccel > 0 {
                let maxAccelS = maxAccel
                let maxAccelTimeS = maxAtime
                
                if (time - spmTime > getMinTimeBetweenStrokes()) {
                    checkThresholds(maxAccelS: maxAccelS, maxAccelTime: maxAccelTimeS)
                }
                maxAccel = 0
                maxAtime = 0
                minAtime = 0
                minAccel = 0
            }
            if minAccel > val {
                minAccel = val
                minAtime = time
            }
            negativeA = true
        }
        
        var logString: String = "\(Int64(time));"
        logString.append("\(getFormattedLogValue(val));")
        logString.append("\(getFormattedLogValue(realVal));")
        logString.append("\((strokes - lastStrokes));")
        logString.append("\((strokesPerMin));")
        logString.append("\((strokes));")
        logString.append("\(getFormattedLogValue(accelThresholdN));")
        logString.append("\(getFormattedLogValue(accelThresholdP));")
        logString.append("\(getFormattedLogValue(gyroY));")
        logString.append("\(getFormattedLogValue(gyroZ));")
        logString.append("\(getFormattedLogValue(Telemetry.sharedInstance.speed));")
        
        KayakLog.logUserData(logString)
        
        lastStrokes = strokes
    }
    
    private func checkThresholds(maxAccelS: Double, maxAccelTime: Double) {
        if countDyn > (dynamicMed.count - 1) {
            countDyn = 0
        }
        
        dynamicMed[countDyn] = maxAccelS
        countDyn += 1
        var f3: Double = 0
        for i in 0..<dynamicMed.count {
            f3 += dynamicMed[i]
        }
        var size = movingAvgMed.calAverage(newValue: (f3 / Double(dynamicMed.count)))
        if 0.5 * size < 0.2 {
            size = movingAvgMed.calAverage(newValue: 0.4)
        }
        
        accelThresholdN = -thresholdCheckUnit * size
        accelThresholdP = size * thresholdCheckUnit
        
        lastSpmTime = telemetry.getAbsoluteTimestamp()
        dynamicTime = telemetry.getAbsoluteTimestamp()
        lastSPM = maxAccelTime
        size = calcSPM(timeA: maxAccelTime)
        if ((ultSPM - size) > (ultSPM * 0.2)) {
            spms.append(size)
            if testSPMArray(array: spms) {
                ultSPM = size
            } else {
                size = ultSPM
            }
        } else {
            if spms.count > 0 {
                spms = [Double]()
            }
            ultSPM = size
        }
        
        setStrokesPerMin(strokesPerMin: ultSPM)
        
        restartStuff(time: maxAccelTime)
    }
    
    private func setStrokesPerMin(strokesPerMin: Double) {
        if self.strokesPerMin < 40 || strokesPerMin <= self.strokesPerMin * 2 {
            
            log("SPM", "think get stroke: " + (abs(self.strokesPerMin - strokesPerMin) > 0.5 ? "true" : "false"))
            
            if abs(self.strokesPerMin - strokesPerMin) > 0.5 {
                self.strokes = self.strokes + 1
            }
            
            self.strokesPerMin = strokesPerMin
        }
    }
    
    private func testSPMArray(array: [Double]) -> Bool {
        if array.count < 3 {
            return false
        }
        for x in 0..<array.count - 1 {
            if ((array[x] - array[x] > 10) || (array[x] - array[x] < -10)) {
                return false
            }
        }
        return true
    }
    
    private func restartStuff(time: Double) {
        positiveA = false
        spmTime = time
    }
    
    private func stopStuff() {
        createDynamicMed()
        
        countDyn = 0
        dynamicTime = -1
        accelThresholdN = -defaultThreshold
        accelThresholdP = defaultThreshold
        lastSpmTime = 0
        initTime = 0
    }
    
    private func createDynamicMed() {
        dynamicMed = [Double]()
        for _ in 0..<(getMovingAverageNum() * 2){
            dynamicMed.append(1)
        }
    }
    
    private func getFormattedLogValue(_ value: Double) -> String {
        return String(format: "%.4f", value)
    }
    
    private func getMovingAverageNum() -> Int {
        return Int(((sampleRate / (AppSensorManager.maxSpm / Double(60))) / Double(2)))
    }
    
    private func getMinTimeBetweenStrokes() -> Double {
        return (1000 / (AppSensorManager.maxSpm / 60))
    }
    
    private func getMaxTimeBetweenStrokes() -> Double {
        return (1000 / (minSpm / 60))
    }
    
    private func shouldSensorRead() -> Bool {
        let telemetry = Telemetry.sharedInstance
        return telemetry.checkCycleState(cycleState: CycleState.resumed)
        //return telemetry.checkCycleState(cycleState: CycleState.resumed) && telemetry.speed > minSpeedKmh
    }
}
