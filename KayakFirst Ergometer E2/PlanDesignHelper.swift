//
//  PlanDesignHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 14..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func setPlanTypeIcon(planType: PlanType?, imageView: UIImageView) {
    if let planType = planType {
        imageView.isHidden = false
        imageView.image = getPlanTypeIcon(planType: planType)
    } else {
        imageView.isHidden = true
    }
}

func getPlanTypeIconSmall(planType: PlanType?) -> UIImage? {
    var image = getPlanTypeIcon(planType: planType)
    
    if image != nil {
        image = image!.resizeImage(targetSize: CGSize(width: 24, height: 24))
    }
    
    return image
}

func getPlanTypeIcon(planType: PlanType?) -> UIImage? {
    if let planType = planType {
        switch planType {
        case PlanType.distance:
            return UIImage(named: "distanceIcon")
        case PlanType.time:
            return UIImage(named: "durationIcon")
        }
    }
    return nil
}
