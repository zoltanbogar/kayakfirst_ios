//
//  TrainingManagerType.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 20..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum TrainingManagerType: Int, BaseManagerType {
    case upload_training = 0
    case upload_training_avg = 1
    case delete_training = 2
    case delete_training_avg = 3
    case download_training_days = 4
    case download_training = 5
    case download_training_avg = 6
    case download_training_sum = 7
    
    func isProgressShown() -> Bool {
        return self.rawValue >= TrainingManagerType.upload_training_avg.rawValue
    }
}
