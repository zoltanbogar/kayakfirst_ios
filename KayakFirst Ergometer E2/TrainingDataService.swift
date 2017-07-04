//
//  TrainingService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingDataService: AppService {
    
    //MARK: init
    static let sharedInstance = TrainingDataService()
    private override init() {
        //private constructor
    }
    
    //MARK: properties
    private var avgTrainingDictionary: [String : Double]?
    var trainingDataCallback: ((_ error: Responses?, _ trainingData: [SumTraining]?) -> ())?
    var trainingDaysCallback: ((_ error: Responses?, _ trainingData: [TimeInterval]?) -> ())?
    var progressListener: ((_ onProgress: Bool) -> ())?
    
    var detailsTrainingList: [SumTraining]?
    
    var progressIndex: Int = 0 {
        didSet {
            if let listener = progressListener {
                listener(progressIndex != 0)
            }
        }
    }
    
    //MARK: upload
    func uploadTrainingData() {
        let uploadTrainingAvgs = UploadTrainingAvgs()
        let uploadTrainings = UploadTrainings()
        
        if UserService.sharedInstance.getUser() != nil {
            DispatchQueue.global().async {
                self.runWithTokenCheck(serverService: uploadTrainingAvgs)
                self.runWithTokenCheck(serverService: uploadTrainings)
            }
        }
    }
    
    //MARK: server endpoints
    func getTrainingDays() {
        let downloadTrainingDays = DownloadTrainingDays()
        LoadTrainingDaysData(
            trainingService: self,
            downloadTrainingDays: downloadTrainingDays).execute()
    }
    
    func getTrainingList(sessionIdFrom: Double, sessionIdTo: Double) {
        let trainingDbLoader = TrainingDbLoader.sharedInstance
        let downloadTrainings = DownloadTrainings(sessionIdFrom: sessionIdFrom, sessionIdTo: sessionIdTo)
        LoadTrainingData(
            trainingService: self,
            trainingDbLoader: trainingDbLoader,
            downloadTrainings: downloadTrainings,
            sessionIdFrom: sessionIdFrom,
            sessionIdTo: sessionIdTo).execute()
    }
    
    func getTrainigAvg(hash: String) -> Double? {
        if let dictionary = avgTrainingDictionary {
            return dictionary[hash]
        }
        return nil
    }
    
    func getTrainingAvgList(sessionIdFrom: Double, sessionIdTo: Double) {
        let trainingAvgDbLoader = TrainingAvgDbLoader.sharedInstance
        putTrainingAvgsToMap(avgs: trainingAvgDbLoader.loadData(predicate: trainingAvgDbLoader.getTrainingAvgsBetweenSessionIdPredicate(sessionIdFrom: sessionIdFrom, sessionIdTo: sessionIdTo)))
        
        let downloadTrainingAvgs = DownloadTrainingAvgs(sessionIdFrom: sessionIdFrom, sessionIdTo: sessionIdTo)
        putTrainingAvgsToMap(avgs: downloadTrainingAvgs.run())
    }
    
    private func putTrainingAvgsToMap(avgs: [TrainingAvg]?) {
        if let trainingAvgs = avgs {
            if self.avgTrainingDictionary == nil {
                self.avgTrainingDictionary = [String : Double]()
            }
            
            for trainingAvg in trainingAvgs {
                self.avgTrainingDictionary!.updateValue(trainingAvg.avgValue, forKey: trainingAvg.avgHash)
            }
        }
    }
}

//MARK: asynctask
private class LoadTrainingDaysData: AsyncTask<Any, [TimeInterval], [TimeInterval]> {
    
    private let trainingService: TrainingDataService
    private let downloadTrainingDays: DownloadTrainingDays
    private let trainingDbLoader = TrainingDbLoader.sharedInstance
    
    init(trainingService: TrainingDataService, downloadTrainingDays: DownloadTrainingDays) {
        self.trainingService = trainingService
        self.downloadTrainingDays = downloadTrainingDays
    }
    
    fileprivate override func doInBackground(param: Any?) -> [TimeInterval]? {
        var trainingDaysList: [TimeInterval]?
        
        trainingDaysList = trainingDbLoader.getTrainingDays()
        
        publishProgress(progress: trainingDaysList)
        
        trainingDaysList = trainingService.runWithTokenCheck(serverService: downloadTrainingDays)
        
        return trainingDaysList
    }
    
    fileprivate override func onProgressUpdate(progress: [TimeInterval]?) {
        if let callbackValue = trainingService.trainingDaysCallback {
            callbackValue(downloadTrainingDays.error, progress)
        }
    }
    
    fileprivate override func onPostExecute(result: [TimeInterval]?) {
        if let callbackValue = trainingService.trainingDaysCallback {
            callbackValue(downloadTrainingDays.error, result)
        }
    }
}

private class LoadTrainingData: AsyncTask<Any, [SumTraining], [SumTraining]> {
    
    private let trainingService: TrainingDataService
    private let trainingDbLoader: TrainingDbLoader
    private let downloadTrainings: DownloadTrainings
    private let sessionIdFrom: Double
    private let sessionIdTo: Double
    
    init(trainingService: TrainingDataService, trainingDbLoader: TrainingDbLoader, downloadTrainings: DownloadTrainings, sessionIdFrom: Double, sessionIdTo: Double) {
        self.trainingService = trainingService
        self.trainingDbLoader = trainingDbLoader
        self.downloadTrainings = downloadTrainings
        self.sessionIdFrom = sessionIdFrom
        self.sessionIdTo = sessionIdTo
        
        trainingService.progressIndex += 1
    }
    
    fileprivate override func doInBackground(param: Any?) -> [SumTraining]? {
        trainingService.getTrainingAvgList(sessionIdFrom: sessionIdFrom, sessionIdTo: sessionIdTo)
        
        var data: [SumTraining]?
        
        let trainings = trainingDbLoader.loadData(predicate: trainingDbLoader.getTrainingsBetweenSessionIdPredicate(sessionIdFrom: sessionIdFrom, sessionIdTo: sessionIdTo))
        
        if let trainingsValue = trainings {
            //TODO
            //data = SumTraining.createSumTrainingList(trainings: trainingsValue)
        }
        
        publishProgress(progress: data)
        
        let downloadedTrainings = trainingService.runWithTokenCheck(serverService: downloadTrainings)
        
        if let downloadedTrainingsValue = downloadedTrainings {
            //TODO
            let downloadedData: [SumTraining]? = nil
            // let downloadedData = SumTraining.createSumTrainingList(trainings: downloadedTrainingsValue)
            
            if data != nil && downloadedData != nil {
                for s in downloadedData! {
                    if !data!.contains(s) {
                        data!.append(s)
                    }
                }
                
                data = data?.sorted(by: {
                    $0.startTime! < $1.startTime!
                })
            } else {
                data = downloadedData
            }
        }
        
        return data
    }
    
    fileprivate override func onProgressUpdate(progress: [SumTraining]?) {
        if let callbackValue = trainingService.trainingDataCallback {
            callbackValue(downloadTrainings.error, progress)
        }
    }
    
    fileprivate override func onPostExecute(result: [SumTraining]?) {
        trainingService.progressIndex -= 1
        
        if let callbackValue = trainingService.trainingDataCallback {
            callbackValue(downloadTrainings.error, result)
        }
    }
}
