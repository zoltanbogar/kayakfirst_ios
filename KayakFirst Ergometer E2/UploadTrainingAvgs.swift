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

class UploadTrainingAvgs: ServerService<Bool> {
    
    //MARK: properties
    private let trainingAvgDbLoader = TrainingAvgDbLoader.sharedInstance
    private var trainingAvgArrayList: Array<[String:Any]>?
    
    //MARK: init
    init(sessionIds: [Double]?) {
        super.init()
        
        if let sessionIds = sessionIds {
            let normalizedSessionIds = sessionIds.map { sessionId in
                Double(Int64(sessionId))
            }
                
            initTrainingList(sessionIds: normalizedSessionIds)
        }
    }
    
    override func preCheck() -> Bool {
        return trainingAvgArrayList != nil && trainingAvgArrayList!.count > 0
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        return true
    }
    
    override func initUrlTag() -> String {
        return "avgtraining/uploadAvgTrainings"
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
    
    private func initTrainingList(sessionIds: [Double]) {
        var arrayList: [String:Any]
        
        var list: Array<[String:Any]> = []
        
        let originalList = trainingAvgDbLoader.loadUploadAbleData(sessionIds: sessionIds)
        
        if originalList != nil && originalList!.count > 0 {
            for trainingAvg in originalList! {
                arrayList = trainingAvg.getParameters()
                
                list.append(arrayList)
            }
            
            self.trainingAvgArrayList = list
        }
    }
    
    override func getManagerType() -> BaseManagerType {
        return TrainingManagerType.upload_training_avg
    }
}
