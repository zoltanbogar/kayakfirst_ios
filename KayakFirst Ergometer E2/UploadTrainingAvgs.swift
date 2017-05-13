//
//  UploadTrainingAvgs.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UploadTrainingAvgs: UploadUtils<Bool> {
    
    //MARK: constants
    private let keyTimeStamp = "db.upload_training_avgs_timestamp"
    
    //MARK: properties
    private let trainingAvgDbLoader = TrainingAvgDbLoader.sharedInstance
    private var trainingAvgArrayList: Array<[String:Any]>?
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        setTimestamp(timestamp: self.timeStamp)
        
        return true
    }
    
    override func preCheck() -> Bool {
        initTrainingList()
        
        return trainingAvgArrayList != nil && trainingAvgArrayList!.count > 0
    }
    
    override func initUrlTag() -> String {
        return "avgtraining/upload"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return trainingAvgArrayList!.asParameters()
    }
    
    override func initEncoding() -> ParameterEncoding {
        return ArrayEncoding()
    }
    
    private func initTrainingList() {
        var arrayList: [String:Any]
        
        var list: Array<[String:Any]> = []
        
        let originalList = trainingAvgDbLoader.loadData(predicate: trainingAvgDbLoader.getTrainingAvgsfromTimeStampPredicate(timeStampFrom: self.getTimestamp()))
        
        if originalList != nil && originalList!.count > 0 {
            for trainingAvg in originalList! {
                if !Telemetry.sharedInstance.checkCycleState(cycleState: CycleState.resumed) {
                    self.timeStamp = trainingAvg.sessionId
                    
                    arrayList = [
                        "userId":"\(trainingAvg.userId))",
                        "sessionId":"\(Int64(trainingAvg.sessionId))",
                        "avgType":"\(trainingAvg.avgType)",
                        "avgValue":"\(trainingAvg.avgValue)"
                    ]
                    
                    list.append(arrayList)
                }
            }
        } else {
            UploadTimer.stopTimer()
        }
        self.trainingAvgArrayList = list
    }
    
    override func getKeyTimeStamp() -> String {
        return keyTimeStamp
    }
}
