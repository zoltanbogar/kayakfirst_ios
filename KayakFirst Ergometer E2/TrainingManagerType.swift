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
    case upload_training_sum = 2
    case delete_training = 3
    case delete_training_avg = 4
    case download_training_days = 5
    case download_training = 6
    case download_training_avg = 7
    case download_training_sum = 8
    
    func isProgressShown() -> Bool {
        return self.rawValue >= TrainingManagerType.upload_training_avg.rawValue
    }
}
