//
//  TrainingDesignHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 14..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func setTrainingTypeIcon(trainingEnvType: String?, imageView: UIImageView) {
    if let trainingEnvType = trainingEnvType {
        imageView.image = getTrainingTypeIcon(trainingEnvType: trainingEnvType)
    }
}

func getTrainingTypeIcon(trainingEnvType: String?) -> UIImage? {
    if let trainingEnvType = trainingEnvType {
        switch trainingEnvType {
        case TrainingEnvironmentType.ergometer.rawValue:
            return UIImage(named: "lightBulbCopy")
        case TrainingEnvironmentType.outdoor.rawValue:
            return UIImage(named: "sunCopy")
        default:
            break
        }
    }
    return nil
}
