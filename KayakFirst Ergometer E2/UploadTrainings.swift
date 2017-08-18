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

class UploadTrainings: ServerService<Bool> {
    
    //MARK: constants
    //TODO: reactivate this
    //private let maxUploadTrainings = 10000
    private let maxUploadTrainings = 3
    
    //MARK: properties
    private let trainingDbLoader = TrainingDbLoader.sharedInstance
    private var trainingArrayList: Array<[String:Any]>?
    
    private var sessionId: Double
    private var timestamp: Double
    
    private var pointerLocale: Double = 0
    var isUploadReady = false
    var pointer: Double = 0
    
    init(sessionId: Double, timestamp: Double) {
        self.sessionId = Double(Int64(sessionId))
        self.timestamp = timestamp
    }
    
    override func preCheck() -> Bool {
        return initTrainingList()
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        pointer = pointerLocale
        
        return isUploadReady
    }
    
    override func getResultFromCache() -> Bool? {
        return isUploadReady
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
    
    private func initTrainingList() -> Bool {
        var arrayList: [String:Any]
        
        var list: Array<[String:Any]> = []
        
        let originalTrainingList = trainingDbLoader.loadUploadAbleData(sessionId: sessionId, timestampPointer: timestamp)
        
        if originalTrainingList != nil && originalTrainingList!.count > 0 {
            
            for i in 0...maxUploadTrainings {
                if i < originalTrainingList!.count {
                    arrayList = originalTrainingList![i].getParameters()
                    list.append(arrayList)
                    
                    pointerLocale = originalTrainingList![i].getUploadPointer()
                } else {
                    break
                }
            }
        }
        
        if originalTrainingList == nil || originalTrainingList?.count == 0 {
            isUploadReady = true
        }
        
        self.trainingArrayList = list
        
        return list.count > 0
    }
    
    override func getManagerType() -> BaseManagerType {
        return TrainingManagerType.upload_training
    }
}
