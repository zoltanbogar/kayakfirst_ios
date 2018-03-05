//
//  TrainingManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingManager: BaseCalendarManager<SumTraining> {
    
    //MARK: init
    static let sharedInstance = TrainingManager()
    private override init() {
        //private constructor
    }
    
    //MARK: properties
    private let saveTrainingValues = SaveTrainingValues.sharedInstance
    
    //MARK: functions
    override func getDays() -> BaseManagerType {
        let sumTrainingDbLoader = SumTrainingDbLoader.sharedInstance
        let downloadTrainingDays = DownloadTrainingDays()
        let managerModifyTrainingDelete = ManagerModifyTrainingDelete(data: nil)
        let managerUploadTrainings = ManagerUploadTrainings()
        
        let managerDownloadTrainingDays = ManagerDownloadTrainingDays(sumTrainingDbLoader: sumTrainingDbLoader, downloadTrainingDays: downloadTrainingDays, managerModifyTrainingDelete: managerModifyTrainingDelete, managerUploadTrainings: managerUploadTrainings)
        runDownload(managerDownload: managerDownloadTrainingDays, managerCallBack: daysCallback)
        
        return TrainingManagerType.download_training_days
    }
    
    override func getDataList(timestampObject: TimestampObject) -> BaseManagerType {
        let manager = ManagerDownloadTraining(timestampObject: timestampObject)
        runDownload(managerDownload: manager, managerCallBack: dataListCallback)
        return TrainingManagerType.download_training
    }
    
    func getTrainingAvg(sessionId: Double, managerCallback: ((_ data: TrainingAvg?, _ error: Responses?) -> ())?) {
        let dbHelper = TrainingAvgDbHelper(sessionId: sessionId)
        runDbLoad(dbHelper: dbHelper, managerCallBack: managerCallback)
    }
    
    func getChartData(sessionId: Double, managerCallback: ((_ data: SumChartTraining?, _ error: Responses?) -> ())?) {
        let dbHelper = TrainingDbHelper(sessionId: sessionId)
        runDbLoad(dbHelper: dbHelper, managerCallBack: managerCallback)
    }
    
    func addTrainingUploadPointer() {
        let sessionId = "\(Telemetry.sharedInstance.sessionId)"
        ManagerUpload.addToStack(uploadType: UploadType.trainingUpload, pointer: sessionId)
    }
    
    func saveTrainingData(training: Training, trainingAvg: TrainingAvg, sumTrainig: SumTraining) {
        saveTrainingValues.saveTrainingData(training: training, trainingAvg: trainingAvg, sumTrainig: sumTrainig)
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
