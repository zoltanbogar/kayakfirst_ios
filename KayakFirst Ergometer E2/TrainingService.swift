//
//  TrainingService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingService: AppService {
    
    //MARK: init
    static let sharedInstance = TrainingService()
    private override init() {
        //private constructor
    }
    
    //MARK: server endpoints
    func getTrainingDays(trainingDataCallback: @escaping (_ error: Responses?, _ userData: [TimeInterval]?) -> ()) {
        let downloadTrainingDays = DownloadTrainingDays()
        LoadData(trainingService: self, trainingDataCallback: trainingDataCallback, serverService: downloadTrainingDays).execute()
    }
}

//MARK: asynctask
private class LoadData<TrainingData>: AsyncTask<Any, TrainingData, TrainingData> {
    
    private var trainingService: TrainingService
    private var trainingDataCallback: (_ error: Responses?, _ userData: TrainingData?) -> ()
    private var serverService: ServerService<TrainingData>
    
    init(trainingService: TrainingService, trainingDataCallback: @escaping (_ error: Responses?, _ trainingData: TrainingData?) -> (), serverService: ServerService<TrainingData>) {
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
