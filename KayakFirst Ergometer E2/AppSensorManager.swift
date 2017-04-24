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
    
    private let maxSpm: Double = 200
    private let minSpm: Double = 24
    private let sampleRate: Double = 50
    private let axisY = 1
    private let axisZ = 2
    private let defaultThreshold: Double = -0.25
    
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
    
    private let pauseDiff = PauseDiff.sharedInstance
    
    var strokesPerMin: Double = 0
    private var strokes: Int = 0
    private var lastStrokes: Int = 0
    
    private var movingAvgAcc = MovingAverage()
    private var movingAvgMed = MovingAverage()
    private var movingAvgGyroY = MovingAverage()
    private var movingAvgGyroZ = MovingAverage()
    
    
    //MARK: init
    static let sharedInstance = AppSensorManager()
    private init() {
        if sensorManager.isAccelerometerAvailable {
            // ~50Hz
            sensorManager.accelerometerUpdateInterval = (1 / sampleRate)
            operationQueue.name = "accelerometer"
        }
    }
    
    //MARK: start/stop
    func startSensorMonitoring(start: Bool) {
        if start {
            reset()
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
        dynamicMed = [Double]()
        for _ in 0..<15 {
            dynamicMed.append(1)
        }
        
        arraySPM = [Double]()
        for _ in 0..<nRows {
            arraySPM.append(-1)
        }
        
        accelThresholdN = -1
        accelThresholdP = 1
        
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
                    initAccelerometerTime = pauseDiff.getAbsoluteTimeStamp()
                }
                
                if ((pauseDiff.getAbsoluteTimeStamp() - initAccelerometerTime) < analyzeTime) {
                    initValues.append([acceleration.x, acceleration.y, acceleration.z])
                }
                
                if ((pauseDiff.getAbsoluteTimeStamp() - initAccelerometerTime) > analyzeTime) {
                    calDefault()
                    initCycle = true
                }
            } else {
                let time = pauseDiff.getAbsoluteTimeStamp()
                if (time - lastSPM > getMaxTimeBetweenStrokes() && accelInit) {
                    lastSPM = time
                }
                
                defCurrentAccel(time: time, y: acceleration.y, z: acceleration.z)
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
        let Vy = f2 / Double(initValues.count)
        let Vz = f3 / Double(initValues.count)
        
        if Vz < 9.81 {
            angleZ = asin((Vz / 9.81))
        } else {
            angleZ = asin(1)
        }
        if angleZ < 45 {
            axis = axisZ
        } else {
            axis = axisY
        }
        removeZ = Vz
        removeY = Vy
        
        factorComp2 = cos(angleZ)
        factorComp = cos((90 / 180 * M_PI) - angleZ)
        
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
        if spmTotal > maxSpm {
            spmTotal = maxSpm
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
            if ((pauseDiff.getAbsoluteTimeStamp() - dynamicTime) > getMaxTimeBetweenStrokes()) {
                if countDyn > 14 {
                    countDyn = 0
                }
                dynamicMed.insert(0, at: countDyn)
                countDyn += 1
                var sum: Double = 0
                for x in 0..<dynamicMed.count {
                    sum += dynamicMed[x]
                }
                var med = sum / Double(dynamicMed.count)
                if 0.5 * med > 0.2 {
                    med = 0.4
                }
                accelThresholdN = -0.8 * med
                accelThresholdP = 0.5 * med
                dynamicTime = pauseDiff.getAbsoluteTimeStamp()
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
        
        var logString: String = "\(time);"
        logString.append("\(getFormattedLogValue(value: val));")
        logString.append("\(realVal);")
        logString.append("\((strokes - lastStrokes));")
        logString.append("\(accelThresholdN);")
        logString.append("\(accelThresholdP);")
        logString.append("\(gyroY);")
        logString.append("\(gyroZ);")
        logString.append("\(Telemetry.sharedInstance.speed)")
        
        logUserData(logString)
        
        lastStrokes = strokes
    }
    
    private func checkThresholds(maxAccelS: Double, maxAccelTime: Double) {
        if countDyn > 14 {
            countDyn = 0
        }
        dynamicMed.insert(maxAccelS, at: countDyn)
        countDyn += 1
        var f3: Double = 0
        for i in 0..<dynamicMed.count {
            f3 += dynamicMed[i]
        }
        var size = f3 / Double(dynamicMed.count)
        if 0.5 * size < 0.2 {
            size = 0.4
        }
        accelThresholdN = -0.8 * size
        accelThresholdP = size * 0.5
        lastSpmTime = pauseDiff.getAbsoluteTimeStamp()
        dynamicTime = pauseDiff.getAbsoluteTimeStamp()
        lastSPM = maxAccelTime
        size = calcSPM(timeA: maxAccelS)
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
        dynamicMed = [Double]()
        for _ in 0..<30 {
            dynamicMed.append(1)
        }
        countDyn = 0
        dynamicTime = 0
        accelThresholdN = -1
        accelThresholdP = 1
        lastSpmTime = 0
        initTime = 0
    }
    
    private func getFormattedLogValue(value: Double) -> String {
        return String(format: "%.4f", value)
    }
    
    private func getMovingAverageNum() -> Int {
        return Int(((sampleRate / (maxSpm / Double(60))) / Double(2)))
    }
    
    private func getMinTimeBetweenStrokes() -> Double {
        return (1000 / (maxSpm / 60))
    }
    
    private func getMaxTimeBetweenStrokes() -> Double {
        return (1000 / (minSpm / 60))
    }
    
    private func shouldSensorRead() -> Bool {
        let telemetry = Telemetry.sharedInstance
        return telemetry.checkCycleState(cycleState: CycleState.resumed) && telemetry.speed > minSpeedKmh
    }
    
}
