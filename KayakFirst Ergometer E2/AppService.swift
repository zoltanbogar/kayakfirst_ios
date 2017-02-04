//
//  AppService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import UIKit

class AppService {
    
    func runWithTokenCheck<E>(serverService: ServerService<E>) -> E? {
        return serverService.run()
    }
    
    private func refreshUserToken() {
        //TODO
    }
    
    static func errorHandlingWithAlert(viewController: UIViewController, error: Responses) {
        let textRes: String
        switch error {
        case Responses.error_no_internet:
            textRes = "error_no_internet"
        case Responses.error_invalid_credentials:
            textRes = "error_user_invalid_credentials"
        default:
            textRes = "error_server"
        }
        ErrorDialog(errorString: getString(textRes)).show(viewController: viewController)
    }
}
