//
//  AppSensorManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreMotion

//TODO: info.plist: https://developer.apple.com/reference/coremotion
class AppSensorManager {
    
    //MARK: constants
    private let analyzeTime: Double = 3000
    private let maxSpm: Double = 200;
    
    //MARK: properties
    private let sensorManager = CMMotionManager()
    private let operationQueue = OperationQueue()
    
    private var arraySPM = [TimeInterval]()
    private let nRows = 3
    private var lastSPM: TimeInterval = 0
    private var accelInit = false
    private var initCycle = false
    
    private var initAccelerometerTime: TimeInterval = 0
    private var valores = [[Double]]()
    private var Vx: Double = 0
    private var Vy: Double = 0
    private var Vz: Double = 0
    private var angleY: Double = 0
    private var angleZ: Double = 0
    private var axis: Int = 0
    
    private var GY: Double = 0
    private var GZ: Double = 0
    private var accelThresholdN: Double = 0
    private var accelThresholdP: Double = 0
    private var countDyn: Int = 0
    private var dynamicMed = [Double]()
    private var dynamicTime: Double = 0
    private var factorComp: Double = 0
    private var factorComp2: Double = 0
    private var flagturningpointY = false
    private var flagturningpointZ = false
    private var gyros = [Double]()
    private var gyrosTimes = [Double]()
    private var initTime: Double = 0
    private var lastSpmTime: Double = 0
    private var maxAccel: Double = 0
    private var maxAtime: Double = 0
    private var minAccel: Double = 0
    private var minAtime: Double = 0
    private var negativeA = false
    private var pointYp = false
    private var pointZp = false
    private var positiveA = false
    private var prevGY: Double = 0
    private var prevGZ: Double = 0
    private var previousrow: Double = 0
    private var relev: Int = 0
    private var removeY: Double = 0
    private var removeZ: Double = 0
    private var spms = [Double]()
    private var spmTime: Double = 0
    private var thresholdGY: Double = 0
    private var thresholdGZ: Double = 0
    private var ultSPM: Double = 0
    
    var strokesPerMin: Double = 0
    
    //MARK: init
    static let sharedInstance = AppSensorManager()
    private init() {
        if sensorManager.isAccelerometerAvailable {
            // ~50Hz
            sensorManager.accelerometerUpdateInterval = 0.02
            operationQueue.name = "accelerometer"
        }
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
    func reset() {
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
        valores = [[Double]]()
        initCycle = false
    }
    
    private func onSensorChanged(acceleration: CMAcceleration) {
        if !initCycle {
            if initAccelerometerTime == 0 {
                initAccelerometerTime = currentTimeMillis()
            }
            
            if ((currentTimeMillis() - initAccelerometerTime) < analyzeTime) {
                valores.append([acceleration.x, acceleration.y, acceleration.z])
            }
            
            if ((currentTimeMillis() - initAccelerometerTime) > analyzeTime) {
                calDefault()
                initCycle = true
                startStuff(angleZ: angleZ, removeY: removeY, removeZ: removeZ)
            }
        } else {
            let time = currentTimeMillis()
            if (time - lastSPM > 2500 && accelInit) {
                lastSPM = time
            }
            
            defCurrentAccel(time: time, x: acceleration.x, y: acceleration.y, z: acceleration.z)
            
        }
    }
    
    private func onSensorChanged(rotationRate: CMRotationRate) {
        GY = rotationRate.y
        GZ = rotationRate.z
    }
    
    private func calDefault() {
        var f: Double = 0
        var f2: Double = 0
        var f3: Double = 0
        for i in 0..<valores.count {
            f += valores[i][0]
            f2 += valores[i][1]
            f3 += valores[i][2]
        }
        Vx = f / Double(valores.count)
        Vy = f2 / Double(valores.count)
        Vz = f3 / Double(valores.count)
        
        if Vz < 9.81 {
            angleZ = asin((Vz / 9.81))
        } else {
            angleZ = asin(1)
        }
        if angleZ < 45 {
            axis = 2
        } else {
            axis = 1
        }
        angleY = acos((Vy / 9.81))
        removeZ = Vz
        removeY = Vy
    }
    
    private func calcSPM(timeA: TimeInterval, timeP: TimeInterval) -> Double {
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
        } else {
            spmTotal = (60 / (timeA - timeP)) / 1000
        }
        if spmTotal > maxSpm {
            spmTotal = maxSpm
        }
        
        strokesPerMin = spmTotal
        
        log("CALCULATE_SPM", "spmTotal: \(spmTotal)")
        
        return spmTotal
    }
    
    private func defCurrentAccel(time: Double, x: Double, y: Double, z: Double) {
        if relev == 2 {
            defAccelState(time: time, val: ((z - removeZ) * factorComp2))
        } else {
            defAccelState(time: time, val: ((y - removeY) * factorComp))
        }
    }
    
    private func defAccelState(time: Double, val: Double) {
        if dynamicTime > 0 {
            if ((currentTimeMillis() - dynamicTime) > 2500) {
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
                accelThresholdN = -0.5 * med
                accelThresholdP = 0.5 * med
                dynamicTime = currentTimeMillis()
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
            if positiveA && minAccel < 0 && maxAccel > 0 {
                let maxAccelS = maxAccel
                let maxAccelTimeS = maxAtime
                let minAccelTimeS = minAtime
                let minAccelS = minAccel
                if (time - spmTime > 150) {
                    checkThresholds(f: maxAccelS, j: maxAccelTimeS)
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
    }
    
    private func checkThresholds(f: Double, j: Double) {
        var obj: Int? = nil
        if initTime == 0 {
            initTime = currentTimeMillis()
            prevGZ = GZ
            prevGY = GY
        }
        if (currentTimeMillis() - lastSpmTime < 300) {
            obj = nil
            var obj2: Int? = nil
            var obj3: Int? = nil
            if prevGZ > 0 {
                if GZ > thresholdGZ {
                    obj = 1
                } else if (GZ < (thresholdGZ * -1)) {
                    obj = 1
                }
            }
            if prevGY > 0 {
                if GY > thresholdGY {
                    obj2 = 1
                } else if (GY < (thresholdGY * -1)) {
                    obj2 = 1
                }
            }
            if (GZ > 0 && GY < 0) || (GZ < 0 && GY > 0) {
                obj3 = 1
            }
            obj = (obj == nil || obj2 == nil || obj3 == nil) ? nil : 1
        } else {
            obj = 1
        }
        if obj != nil {
            prevGZ = GZ
            prevGY = GY
            if countDyn > 14 {
                countDyn = 0
            }
            dynamicMed.insert(f, at: countDyn)
            countDyn += 1
            var f3: Double = 0
            for i in 0..<dynamicMed.count {
                f3 += dynamicMed[i]
            }
            var size = f3 / Double(dynamicMed.count)
            if 0.5 * size < 0.2 {
                size = 0.4
            }
            accelThresholdN = -0.5 * size
            accelThresholdP = size * 0.5
            lastSpmTime = currentTimeMillis()
            dynamicTime = currentTimeMillis()
            lastSPM = j
            size = calcSPM(timeA: j, timeP: previousrow)
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
            
            restartStuff(max: f, time: j)
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
    
    private func restartStuff(max: Double, time: Double) {
        positiveA = false
        spmTime = 0
    }
    
    private func startStuff(angleZ: Double, removeY: Double, removeZ: Double) {
        if ((angleZ * 180 / M_PI) >= 45) {
            relev = 1
        } else {
            relev = 2
        }
        thresholdGY = 0
        thresholdGZ = 0
        GY = 0
        GZ = 0
        prevGZ = 0
        prevGY = 0
        factorComp2 = cos(angleZ)
        factorComp = cos((90 / 180 * M_PI) - angleZ)
        self.removeZ = removeZ
        self.removeY = removeY
        thresholdGY = 0.3 * factorComp
        thresholdGZ = 0.3 * factorComp2
        arraySPM = [Double]()
        spms = [Double]()
        for _ in 0..<nRows {
            arraySPM.append(-1)
        }
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
    
}
