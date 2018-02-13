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
    private var sumTraining: SumTrainingNew!
    
    //MARK: init
    init(frame: CGRect, sumTraining: SumTrainingNew) {
        self.sumTraining = sumTraining
        super.init()
        
        self.frame = frame
        
        initSumElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func getContentLayout(contentView: UIView) -> ViewTrainingSumLayout {
        return ViewTrainingSumLayout(contentView: contentView, sumTraining: sumTraining)
    }
    
    private func initSumElements() {
        contentLayout?.progressBar.showProgressBar(true)
        
        TrainingManager.sharedInstance.getTrainingAvg(sessionId: sumTraining.sessionId, managerCallback: { (trainingAvgNew, error) in
            if let data = trainingAvgNew {
                self.contentLayout?.seSpeedAv.sumData = data.speed
                self.contentLayout?.seStrokeAv.sumData = data.strokes
                self.contentLayout?.seForceAv.sumData = data.force
                self.contentLayout?.seT1000Av.sumData = data.t1000
                self.contentLayout?.seT500Av.sumData = data.t500
                self.contentLayout?.seT200Av.sumData = data.t200
            }
            
            self.contentLayout?.progressBar.showProgressBar(false)
            })
    }
    
}
