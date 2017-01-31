//
//  AsyncTask.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 31..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class AsyncTask<Param, Progress, Result> {
    
    internal init() {
        //internal constructor
    }
    
    func execute(param: Param?) {
        var result: Result?
        
        onPreExecute()
        
        DispatchQueue.global().async {
            result = self.doInBackground(param: param)
            
            DispatchQueue.main.async {
                self.onPostExecute(result: result)
            }
        }
    }
    
    internal func onPreExecute() {
        //nothing here
    }
    
    internal func doInBackground(param: Param?) -> Result? {
        fatalError("It must be implemented")
    }
    
    internal func onProgressUpdate(progress: Progress?) {
        //nothing here
    }
    
    internal func publishProgress(progress: Progress?) {
        DispatchQueue.main.async {
            self.onProgressUpdate(progress: progress)
        }
    }
    
    internal func onPostExecute(result: Result?) {
        //nothing here
    }
    
}
