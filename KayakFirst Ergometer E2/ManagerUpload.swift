//
//  ManagerUpload.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerUpload {
    
    //MARK: properties
    private static let preferences = UserDefaults.standard
    
    //MARK: functions
    func callServer() {
        let serverWasReachable = runServer(pointers: getPointers())
        
        if serverWasReachable {
            removeFromStack(uploadType: getUploadType())
        }
    }
    
    class func getStack() -> [String]? {
        let dictionary = getDictionary()
        
        var stack = [String]()
        
        for key in dictionary.keys {
            stack.append(key)
        }
        
        return stack
    }
    
    class func addToStack(uploadType: UploadType, pointer: String?) {
        if UserManager.sharedInstance.getUser() != nil {
            UploadTimer.startTimer()
            
            var dictionary = getDictionary()
            
            var values: [String] = dictionary[uploadType.rawValue] ?? [String]()
            
            if pointer != nil && !values.contains(pointer!) {
                values.append(pointer!)
            }
            
            dictionary.updateValue(values, forKey: uploadType.rawValue)
            
            preferences.setPersistentDomain(dictionary, forName: getDbUpload())
            preferences.synchronize()
        }
    }
    
    class func getManagerUploadByType(uploadType: String) -> [ManagerUpload] {
        var managerUploads = [ManagerUpload]()
        
        switch uploadType {
        case UploadType.trainingUpload.rawValue:
            managerUploads.append(ManagerUploadTrainings())
        case UploadType.trainingAvgUpload.rawValue:
            managerUploads.append(ManagerUploadTrainingAvgs())
        case UploadType.planSave.rawValue:
            managerUploads.append(ManagerModifyPlanSave(data: nil))
        case UploadType.planDelete.rawValue:
            managerUploads.append(ManagerModifyPlanDelete(data: nil))
        case UploadType.eventSave.rawValue:
            managerUploads.append(ManagerModifyEventSave(data: nil))
        case UploadType.eventDelete.rawValue:
            managerUploads.append(ManagerModifyEventDelete(data: nil))
        case UploadType.planTrainingSave.rawValue:
            managerUploads.append(ManagerModifyPlanTrainingSave(data: nil))
        case UploadType.trainingDelete.rawValue:
            managerUploads.append(ManagerModifyTrainingDelete(data: nil))
        default:
            break
        }
        
        return managerUploads
    }
    
    internal func removeFromStack(uploadType: UploadType) {
        
        var dictionary = ManagerUpload.getDictionary()
        
        dictionary.removeValue(forKey: uploadType.rawValue)
        ManagerUpload.preferences.setPersistentDomain(dictionary, forName: ManagerUpload.getDbUpload())
        ManagerUpload.preferences.synchronize()
    }
    
    internal func getPointers() -> [String]? {
        let dictionary = ManagerUpload.getDictionary()
        
        let pointers = dictionary[getUploadType().rawValue] ?? [String]()
        
        return pointers
    }
    
    private class func getDictionary() -> [String : [String]] {
        return preferences.persistentDomain(forName: getDbUpload()) as? [String : [String]] ?? [String : [String]]()
    }
    
    private class func getDbUpload() -> String {
        let user = UserManager.sharedInstance.getUser()
        
        var preferencesDb = "manager_upload_db"
        
        if let userValue = user {
            preferencesDb = preferencesDb + "_" + String(userValue.id)
        }
        
        return preferencesDb
    }
    
    //MARK: abstract functions
    internal func runServer(pointers: [String]?) -> Bool {
        fatalError("must be implemented")
    }
    
    internal func getUploadType() -> UploadType {
        fatalError("must be implemented")
    }
    
}
