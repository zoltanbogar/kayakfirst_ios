//
//  TrainingService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingServerService: AppService {
    
    //MARK: init
    static let sharedInstance = TrainingServerService()
    private override init() {
        //private constructor
    }
    
    //MARK: properties
    private var avgTrainingDictionary: [String : Double]?
    
    //MARK: server endpoints
    func getTrainingDays(trainingDataCallback: @escaping (_ error: Responses?, _ trainingData: [TimeInterval]?) -> ()) {
        let downloadTrainingDays = DownloadTrainingDays()
        LoadData(trainingService: self, trainingDataCallback: trainingDataCallback, serverService: downloadTrainingDays).execute()
    }
    
    func getTrainingList(trainingDataCallback: @escaping (_ error: Responses?, _ trainingData: [Training]?) -> (), timeStampFrom: TimeInterval, timeStampTo: TimeInterval) {
        getTrainingAvgList(trainingDataCallback: { error, trainingData in
            if let trainingAvgs = trainingData {
                //TODO: hashmap
                
                if self.avgTrainingDictionary == nil {
                    self.avgTrainingDictionary = [String : Double]()
                }
                
                for trainingAvg in trainingAvgs {
                    self.avgTrainingDictionary!.updateValue(trainingAvg.avgValue, forKey: trainingAvg.avgHash)
                }
                
                self.getTrainingListLocale(trainingDataCallback: trainingDataCallback, timeStampFrom: timeStampFrom, timeStampTo: timeStampTo)
            }
        },
            timeStampFrom: timeStampFrom, timeStampTo: timeStampTo)
    }
    
    func getTrainigAvg(hash: String) -> Double? {
        if let dictionary = avgTrainingDictionary {
            return dictionary[hash]
        }
        return nil
    }
    
    private func getTrainingAvgList(trainingDataCallback: @escaping (_ error: Responses?, _ trainingData: [TrainingAvg]?) -> (), timeStampFrom: TimeInterval, timeStampTo: TimeInterval) {
        let downloadTrainingAvgs = DownloadTrainingAvgs(sessionIdFrom: timeStampFrom, sessionIdTo: timeStampTo)
        LoadData(trainingService: self, trainingDataCallback: trainingDataCallback, serverService: downloadTrainingAvgs).execute()
    }
    
    private func getTrainingListLocale(trainingDataCallback: @escaping (_ error: Responses?, _ trainingData: [Training]?) -> (), timeStampFrom: TimeInterval, timeStampTo: TimeInterval) {
        let downloadTrainigs = DownloadTrainings(sessionIdFrom: timeStampFrom, sessionIdTo: timeStampTo)
        LoadData(trainingService: self, trainingDataCallback: trainingDataCallback, serverService: downloadTrainigs).execute()
    }
}

//MARK: asynctask
private class LoadData<TrainingData>: AsyncTask<Any, TrainingData, TrainingData> {
    
    private var trainingService: TrainingServerService
    private var trainingDataCallback: (_ error: Responses?, _ userData: TrainingData?) -> ()
    private var serverService: ServerService<TrainingData>
    
    init(trainingService: TrainingServerService, trainingDataCallback: @escaping (_ error: Responses?, _ trainingData: TrainingData?) -> (), serverService: ServerService<TrainingData>) {
        self.trainingService = trainingService
        self.trainingDataCallback = trainingDataCallback
        self.serverService = serverService
    }
    
    //TODO
    internal override func doInBackground(param: Any?) -> TrainingData? {
        return trainingService.runWithTokenCheck(serverService: serverService)
    }
    
    //TODO
    internal override func onPostExecute(result: TrainingData?) {
        trainingDataCallback(serverService.error, result)
    }
    
}
