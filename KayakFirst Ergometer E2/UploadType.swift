//
//  UploadType.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum UploadType: String {
    case pushIdUpload = "0_push_id_upload"
    case trainingUpload = "1_training_upload"
    case trainingAvgUpload = "2_training_avg_upload"
    case trainingSumUpload = "3_training_sum_upload"
    case planSave = "4_plan_save"
    case eventSave = "5_event_save"
    case planTrainingSave = "6_plan_training_save"
    case planDelete = "7_plan_delete"
    case eventDelete = "8_event_delete"
    case trainingDelete = "9_training_delete"
    
    func shouldWaitForIt() -> Bool {
        return self != UploadType.pushIdUpload
    }
    
    func shouldWaitForPlan() -> Bool {
        return self == UploadType.planSave || self == UploadType.planDelete || self == UploadType.eventSave || self == UploadType.eventDelete || self == UploadType.planTrainingSave
    }
}
