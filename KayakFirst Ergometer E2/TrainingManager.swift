//
//  TrainingManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingManager: BaseManager {
    
    //MARK: init
    static let sharedInstance = TrainingManager()
    private override init() {
        //private constructor
    }
    
    //MARK: properties
    private let saveTrainingValues = SaveTrainingValues.sharedInstance
    
    //MARK: callbacks
    var trainingCallback: ((_ data: [SumTrainingNew]?, _ error: Responses?) -> ())?
    var trainingDaysCallback: ((_ data: [Double]?, _ error: Responses?) -> ())?
    
    //MARK: functions
    func getTrainingDays() -> BaseManagerType {
        let managerDownloadTrainingDays = ManagerDownloadTrainingDays()
        runDownload(managerDownload: managerDownloadTrainingDays, managerCallBack: trainingDaysCallback)
        return TrainingManagerType.download_training_days
    }
    
    func downloadSumTrainings(sessionIds: [Double]) -> BaseManagerType {
        let manager = ManagerDownloadTrainingBySessionId(sessionIds: sessionIds)
        runDownload(managerDownload: manager, managerCallBack: trainingCallback)
        
        return TrainingManagerType.download_training
    }
    
    func getTrainingAvg(sessionId: Double, managerCallback: ((_ data: TrainingAvgNew?, _ error: Responses?) -> ())?) {
        let dbHelper = TrainingAvgDbHelper(sessionId: sessionId)
        runDbLoad(dbHelper: dbHelper, managerCallBack: managerCallback)
    }
    
    func addTrainingUploadPointer() {
        //TODO
        /*let sessionId = "\(Telemetry.sharedInstance.sessionId)"
        ManagerUpload.addToStack(uploadType: UploadType.trainingUpload, pointer: sessionId)
        ManagerUpload.addToStack(uploadType: UploadType.trainingAvgUpload, pointer: sessionId)*/
    }
    
    func saveTrainingData(training: TrainingNew, trainingAvg: TrainingAvgNew, sumTrainig: SumTrainingNew) {
        saveTrainingValues.saveTrainingData(training: training, trainingAvg: trainingAvg, sumTrainig: sumTrainig)
    }
    
    func deleteTraining(sumTraining: SumTrainingNew, managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) -> BaseManagerType {
        let manager = ManagerModifyTrainingDelete(data: sumTraining)
        runModify(managerModify: manager, managerCallBack: managerCallback)
        return TrainingManagerType.delete_training
    }
    
    func deleteOldData() {
        if !ManagerUpload.hasStackToWait() {
            DispatchQueue.global().async {
                let trainingDbLoader = TrainingDbLoader.sharedInstance
                trainingDbLoader.deleteData(predicate: trainingDbLoader.getDeleteOldDataPredicate())
                
                let trainingAvgDbLoader = TrainingAvgDbLoader.sharedInstance
                trainingAvgDbLoader.deleteData(predicate: trainingAvgDbLoader.getDeleteOldDataPredicate())
            }
        }
    }
}
