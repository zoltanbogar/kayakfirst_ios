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

//TODO
class UploadTrainingAvgs: ServerService<Bool> {
    
    //MARK: properties
    private let trainingAvgDbLoader = TrainingAvgDbLoader.sharedInstance
    private var trainingAvgArrayList: Array<[String:Any]>?
    
    var isUploadReady = false
    
    //MARK: init
    init(sessionId: Double) {
        super.init()
        initTrainingList(sessionId: sessionId)
    }
    
    override func preCheck() -> Bool {
        return isUploadReady
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        return true
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
    
    private func initTrainingList(sessionId: Double) {
        var arrayList: [String:Any]
        
        var list: Array<[String:Any]> = []
        
        let originalList = trainingAvgDbLoader.loadUploadAbleData(pointer: sessionId)
        
        if originalList != nil && originalList!.count > 0 {
            for trainingAvg in originalList! {
                arrayList = trainingAvg.getParameters()
                
                list.append(arrayList)
            }
        }
        
        isUploadReady = list.count > 0
    }
    
    override func getManagerType() -> BaseManagerType {
        return TrainingManagerType.upload_training_avg
    }
}
