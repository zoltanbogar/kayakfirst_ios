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


//TODO
class UploadTrainings: ServerService<Bool> {
    
    //MARK: constants
    private let maxUploadTrainings = 10000
    
    //MARK: properties
    private let trainingDbLoader = TrainingDbLoader.sharedInstance
    private var trainingArrayList: Array<[String:Any]>?
    
    private var timestamp: Double
    private var pointerLocale: Double = 0
    var isUploadReady = false
    var pointer: Double = 0
    
    init(timestamp: String?) {
        if timestamp == nil {
            self.timestamp = 0
        } else {
            self.timestamp = Double(timestamp!)!
        }
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
        
        let originalTrainingList = trainingDbLoader.loadUploadAbleData(pointer: timestamp)
        
        if originalTrainingList != nil && originalTrainingList!.count > 0 {
            
            for i in 0...maxUploadTrainings {
                arrayList = originalTrainingList![i].getParameters()
                list.append(arrayList)
                
                pointerLocale = originalTrainingList![i].getUploadPointer()
            }
        }
        
        if originalTrainingList == nil || originalTrainingList?.count == 0 {
            isUploadReady = true
        }
        
        return list.count > 0
    }
    
    override func getManagerType() -> BaseManagerType {
        return TrainingManagerType.upload_training
    }
}
