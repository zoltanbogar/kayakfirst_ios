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
    
    var detailsTrainingList: [SumTraining]?
    
    //MARK: callbacks
    var trainingCallback: ((_ data: [SumTraining]?, _ error: Responses?) -> ())?
    var trainingDaysCallback: ((_ data: [Double]?, _ error: Responses?) -> ())?
    
    //MARK: functions
    func getTrainingDays() -> BaseManagerType {
        let managerDownloadTrainingDays = ManagerDownloadTrainingDays()
        runDownload(managerDownload: managerDownloadTrainingDays, managerCallBack: trainingDaysCallback)
        return TrainingManagerType.download_training_days
    }
    
    func downloadTrainings(sessionIds: [Double]) -> BaseManagerType {
        let manager = ManagerDownloadTrainingBySessionId(sessionIds: sessionIds)
        runDownload(managerDownload: manager, managerCallBack: { data, error in
            
            self.detailsTrainingList = data
            
            if let callback = self.trainingCallback {
                callback(data, error)
            }
        })
        
        return TrainingManagerType.download_training
    }
    
    //TODO: not upload data
    func addTrainingUploadPointer() {
        let sessionId = "\(Telemetry.sharedInstance.sessionId)"
        ManagerUpload.addToStack(uploadType: UploadType.trainingUpload, pointer: sessionId)
        ManagerUpload.addToStack(uploadType: UploadType.trainingAvgUpload, pointer: sessionId)
    }
    
    func saveTraining(training: Training) {
        saveTrainingValues.addValue(training: training)
    }
    
    func saveTrainingAvg(telemetryObject: TelemetryObject, telemetryAvgObject: TelemetryAvgObject) {
        saveTrainingValues.saveTrainingAvgData(telemetryObject: telemetryObject, telemetryAvgObject: telemetryAvgObject)
    }
    
    func deleteTraining(sumTraining: SumTraining, managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) -> BaseManagerType {
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
