//
//  UploadTrainingSums.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 03. 05..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UploadTrainingSums: ServerService<Bool> {
    
    //MARK: properties
    private let sumTrainingDbLoader = SumTrainingDbLoader.sharedInstance
    private var dataList: Array<[String:Any]>?
    
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
        return dataList != nil && dataList!.count > 0
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        return true
    }
    
    override func initUrlTag() -> String {
        return "training/uploadSumTrainings"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return dataList!.asParameters()
    }
    
    override func initEncoding() -> ParameterEncoding {
        return ArrayEncoding()
    }
    
    private func initTrainingList(sessionIds: [Double]) {
        var arrayList: [String:Any]
        
        var list: Array<[String:Any]> = []
        
        let originalList = sumTrainingDbLoader.loadUploadAbleData(sessionIds: sessionIds)
        
        if originalList != nil && originalList!.count > 0 {
            for trainingSum in originalList! {
                arrayList = trainingSum.getParameters()
                
                list.append(arrayList)
            }
            
            self.dataList = list
        }
    }
    
    override func getManagerType() -> BaseManagerType {
        return TrainingManagerType.upload_training_sum
    }
    
}
