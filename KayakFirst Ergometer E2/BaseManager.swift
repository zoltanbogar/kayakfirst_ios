//
//  BaseManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 20..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//
import Foundation

func errorHandlingWithAlert(viewController: UIViewController, error: Responses?) {
    if let errorValue = error {
        let textRes: String
        var isNoInternet = false
        
        switch errorValue {
        case Responses.error_no_internet:
            textRes = "error_no_internet"
            isNoInternet = true
        case Responses.error_invalid_credentials:
            textRes = "error_user_invalid_credentials"
        case Responses.error_registration_required:
            textRes = "user_registration_required"
        case Responses.error_used_username:
            textRes = "error_user_username_used"
        case Responses.error_used_email:
            textRes = "error_user_email_used"
        default:
            textRes = "error_server"
        }
        
        if viewController is BaseVC && isNoInternet {
            AppToast(baseVc: viewController as! BaseVC, text: getString(textRes)).show()
        } else {
            ErrorDialog(errorString: getString(textRes)).show(viewController: viewController)
        }
    }
}

class BaseManager {
    
    //MARK: properties
    var userStack: BaseManagerType?
    
    private var managerDownloadServerList: [ManagerDownloadProtocol]?
    private var managerDownloadLocaleList: [ManagerDownloadProtocol]?
    
    private var uploadRunning = false
    
    //MARK: init
    internal init() {
        //private constructor
    }
    
    //MARK: functions
    func runUser<E>(serverService: ServerService<E>, managerCallBack: ((_ userData: E?, _ error: Responses?) -> ())?) {
        if shouldRunUser() {
            LoadUserData(userDataCallBack: managerCallBack, serverService: serverService, baseManager: self).execute()
        }
    }
    
    func runUpload() {
        if !uploadRunning {
            Upload(baseManager: self).execute()
        }
    }
    
    func runDownload<E>(managerDownload: ManagerDownload<[E]>, managerCallBack: ((_ data: [E]?, _ error: Responses?) -> ())?) {
        Download(managerCallback: managerCallBack, managerDownload: managerDownload, baseManager: self).execute()
    }
    
    func runModify<E: ModifyAble>(managerModify: ManagerModify<E>, managerCallBack: ((_ data: Bool?, _ error: Responses?) -> ())?) {
        Modify(managerCallback: managerCallBack, managerModify: managerModify).execute()
    }
    
    private func shouldRunUser() -> Bool {
        return self.userStack == nil
    }
    
    private func shouldRunDownload(managerDownload: ManagerDownloadProtocol) -> Bool {
        var contains = false
        if managerDownloadServerList != nil {
            contains = managerDownloadServerList?.contains(where: {$0.isEqual(anotherManagerDownload: managerDownload)}) ?? false
        }
        
        return !contains
    }
    
    private func shouldRunDownloadLocale(managerDownload: ManagerDownloadProtocol) -> Bool {
        var contains = false
        if managerDownloadLocaleList != nil {
            contains = managerDownloadLocaleList?.contains(where: {$0.isEqual(anotherManagerDownload: managerDownload)}) ?? false
        }
        
        return !contains
    }
    
    //MARK: helper
    private func handlePreExecuteUser<E>(serverService: ServerService<E>) {
        self.userStack = serverService.getManagerType()
    }
    
    private func handlePostExecuteUser() {
        self.userStack = nil
    }
    
    private func handlePreExecuteDownload(managerDownload: ManagerDownloadProtocol) {
        if managerDownloadServerList == nil {
            managerDownloadServerList = [ManagerDownloadProtocol]()
        }
        managerDownloadServerList?.append(managerDownload)
    }
    
    private func handlePreExecuteDownloadLocale(managerDownload: ManagerDownloadProtocol) {
        if managerDownloadLocaleList == nil {
            managerDownloadLocaleList = [ManagerDownloadProtocol]()
        }
        managerDownloadLocaleList?.append(managerDownload)
    }
    
    private func handlePostExecuteDownload(managerDownload: ManagerDownloadProtocol) {
        if managerDownloadServerList != nil {
            for i in 0..<managerDownloadServerList!.count {
                
                if managerDownloadServerList![i].isEqual(anotherManagerDownload: managerDownload) {
                    managerDownloadServerList!.remove(at: i)
                    break
                }
            }
        }
    }
    
    private func handlePublishDownload(managerDownload: ManagerDownloadProtocol) {
        if managerDownloadLocaleList != nil {
            for i in 0..<managerDownloadLocaleList!.count {
                
                if managerDownloadLocaleList![i].isEqual(anotherManagerDownload: managerDownload) {
                    managerDownloadLocaleList!.remove(at: i)
                    break
                }
            }
        }
    }
    
    //MARK: AsyncTasks
    private class LoadUserData<E>: AsyncTask<Any, Any, E> {
        
        let userDataCallBack: ((_ userData: E?, _ error: Responses?) -> ())?
        let serverService: ServerService<E>
        let baseManager: BaseManager
        
        init(userDataCallBack: ((_ userData: E?, _ error: Responses?) -> ())?,
             serverService: ServerService<E>,
             baseManager: BaseManager) {
            self.userDataCallBack = userDataCallBack
            self.serverService = serverService
            self.baseManager = baseManager
        }
        
        override func onPreExecute() {
            super.onPreExecute()
            
            baseManager.handlePreExecuteUser(serverService: serverService)
        }
        
        override func doInBackground(param: Any?) -> E? {
            return serverService.run()
        }
        
        override func onPostExecute(result: E?) {
            baseManager.handlePostExecuteUser()
            
            if let callback = userDataCallBack {
                callback(result, serverService.error)
            }
        }
    }
    
    private class Upload: AsyncTask<Any, Any, Bool> {
        
        private let baseManager: BaseManager
        
        init(baseManager: BaseManager) {
            self.baseManager = baseManager
        }
        
        override func onPreExecute() {
            baseManager.uploadRunning = true
        }
        
        override func doInBackground(param: Any?) -> Bool? {
            let stack = ManagerUpload.getStack()
            
            if let stackValue = stack {
                if stackValue.count > 0 {
                    for s in stackValue {
                        let managerUploadList = ManagerUpload.getManagerUploadByType(uploadType: s)
                        
                        for managerUpload in managerUploadList {
                            managerUpload.callServer()
                        }
                    }
                } else {
                    UploadTimer.stopTimer()
                }
            }
            
            return true
        }
        
        override func onPostExecute(result: Bool?) {
            super.onPostExecute(result: result)
            
            baseManager.uploadRunning = false
        }
    }
    
    private class Modify<E: ModifyAble>: AsyncTask<Any, Any, Bool> {
        
        private let managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
        private let managerModify: ManagerModify<E>
        
        init(managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?,
             managerModify: ManagerModify<E>) {
            self.managerCallback = managerCallback
            self.managerModify = managerModify
        }
        
        override func doInBackground(param: Any?) -> Bool? {
            managerModify.modifyLocale()
            
            ManagerUpload.addToStack(uploadType: managerModify.getUploadType(), pointer: managerModify.getPointer())
            
            return true
        }
        
        override func onPostExecute(result: Bool?) {
            super.onPostExecute(result: result)
            
            if let callback = managerCallback {
                callback(true, nil)
            }
        }
        
    }
    
    private class Download<E>: AsyncTask<Any, [E], [E]> {
        
        private let managerCallback: ((_ data: [E]?, _ error: Responses?) -> ())?
        private let managerDownload: ManagerDownload<[E]>
        private let baseManager: BaseManager
        
        init(managerCallback: ((_ data: [E]?, _ error: Responses?) -> ())?,
             managerDownload: ManagerDownload<[E]>,
             baseManager: BaseManager) {
            self.managerCallback = managerCallback
            self.managerDownload = managerDownload
            self.baseManager = baseManager
        }
        
        override func doInBackground(param: Any?) -> [E]? {
            var dataFromServer: [E]? = nil
            
            if baseManager.shouldRunDownloadLocale(managerDownload: managerDownload as! ManagerDownloadProtocol) {
                baseManager.handlePreExecuteDownloadLocale(managerDownload: managerDownload as! ManagerDownloadProtocol)
                
                let dataFromLocale = managerDownload.getDataFromLocale()
                
                dataFromServer = dataFromLocale
                
                publishProgress(progress: dataFromLocale)
            }
            
            if baseManager.shouldRunDownload(managerDownload: managerDownload as! ManagerDownloadProtocol) {
                baseManager.handlePreExecuteDownload(managerDownload: managerDownload as! ManagerDownloadProtocol)
                
                if (!managerDownload.shouldWaitForStack() || !ManagerUpload.hasStackToWait()) {
                    if managerDownload.isCacheInvalid() {
                        let serverError = managerDownload.callServer()
                        
                        if serverError == nil {
                            dataFromServer = managerDownload.getDataFromServer()
                        }
                    }
                }
            }
            
            return dataFromServer
        }
        
        override func onProgressUpdate(progress: [E]?) {
            super.onProgressUpdate(progress: progress)
            
            baseManager.handlePublishDownload(managerDownload: managerDownload as! ManagerDownloadProtocol)
            
            publish(data: progress)
        }
        
        override func onPostExecute(result: [E]?) {
            baseManager.handlePostExecuteDownload(managerDownload: managerDownload as! ManagerDownloadProtocol)
            
            publish(data: result)
        }
        
        private func publish(data: [E]?) {
            if let callback = managerCallback {
                callback(data, managerDownload.serverError)
            }
        }
    }
}
