//
//  TrainingSumView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TrainingSumView: CustomUi<ViewTrainingSumLayout> {
    
    //MARK: properties
    private var position: Int?
    private var sumTraining: SumTraining?
    
    //MARK: init
    init(frame: CGRect, position: Int) {
        self.position = position
        self.sumTraining = TrainingManager.sharedInstance.detailsTrainingList![position]
        super.init()
        
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func getContentLayout(contentView: UIView) -> ViewTrainingSumLayout {
        return ViewTrainingSumLayout(contentView: contentView, position: position!)
    }
    
}
