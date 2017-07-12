//
//  UploadType.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum UploadType: String {
    case pushIdUpload = "push_id_upload"
    case trainingUpload = "training_upload"
    case trainingAvgUpload = "training_avg_upload"
    case planSave = "plan_save"
    case planDelete = "plan_delete"
    case eventSave = "event_save"
    case eventDelete = "event_delete"
    case planTrainingSave = "plan_training_save"
    case trainingDelete = "training_delete"
}
