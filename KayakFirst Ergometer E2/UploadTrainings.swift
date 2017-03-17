//
//  UploadTrainings.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UploadTrainings: UploadUtils<Bool> {
    
    //MARK: constants
    private let maxUploadTrainings = 10000
    private let keyTimeStamp = "db.upload_trainings_timestamp"
    
    //MARK: properties
    private let trainingDbLoader = TrainingDbLoader()
    private var trainingArrayList: Array<[String:Any]>?
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        setTimestamp(timestamp: self.timeStamp)
        
        return true
    }
    
    override func preCheck() -> Bool {
        initTrainingList()
        
        return trainingArrayList != nil && trainingArrayList!.count > 0
    }
    
    override func initUrlTag() -> String {
        return "training/upload"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return trainingArrayList!.asParameters()
    }
    
    override func initEncoding() -> ParameterEncoding {
        return ArrayEncoding()
    }
    
    private func initTrainingList() {
        var arrayList: [String:Any]
        
        var list: Array<[String:Any]> = []
        
        let originalTrainingList = trainingDbLoader.loadData(predicate: trainingDbLoader.getTrainingsFromTimeStampPredicate(timeStampFrom: self.getTimestamp()))
        
        if originalTrainingList != nil && originalTrainingList!.count > 0 {
            for training in originalTrainingList! {
                self.timeStamp = training.timeStamp
                
                if list.count <= maxUploadTrainings {
                    arrayList = [
                        "timestamp":"\(Int64(training.timeStamp))",
                        "currentDistance":"\(training.currentDistance)",
                        "userId":"\(training.userId!)",
                        "sessionId":"\(Int64(training.sessionId))",
                        "trainingType":"\(training.trainingType)",
                        "trainingEnvironmentType":"\(training.trainingEnvironmentType)",
                        "dataType":"\(training.dataType)",
                        "dataValue":"\(training.dataValue)"
                    ]
                    
                    list.append(arrayList)
                    
                } else {
                    break
                }
            }
        } else {
            UploadTimer.stopTimer()
        }
        self.trainingArrayList = list
    }
    
    override func getKeyTimeStamp() -> String {
        return keyTimeStamp
    }
    
}
