//
//  TrainingSumView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TrainingSumView: UIView {
    
    //MARK: properties
    private var position: Int?
    private var sumTraining: SumTraining?
    
    //MARK: init
    init(frame: CGRect, position: Int) {
        self.position = position
        self.sumTraining = TrainingDataService.sharedInstance.detailsTrainingList![position]
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: views
    private func initView() {
        let scrollView = AppScrollView(view: self)
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = margin05
        
        mainStackView.addArrangedSubview(labelAverage)
        labelAverage.snp.makeConstraints { (make) in
            make.height.equalTo(labelAverage.intrinsicContentSize.height)
        }
        
        let horizontalStackView1 = UIStackView()
        horizontalStackView1.axis = .horizontal
        horizontalStackView1.distribution = .fillEqually
        horizontalStackView1.addArrangedSubview(seT1000Av)
        horizontalStackView1.addArrangedSubview(seT500Av)
        horizontalStackView1.addArrangedSubview(seT200Av)
        mainStackView.addArrangedSubview(horizontalStackView1)
        
        let horizontalStackView2 = UIStackView()
        horizontalStackView2.axis = .horizontal
        horizontalStackView2.distribution = .fillEqually
        horizontalStackView2.addArrangedSubview(seSpeedAv)
        horizontalStackView2.addArrangedSubview(seStrokeAv)
        horizontalStackView2.addArrangedSubview(seForceAv)
        mainStackView.addArrangedSubview(horizontalStackView2)
        
        mainStackView.addArrangedSubview(labelBest)
        labelBest.snp.makeConstraints { (make) in
            make.height.equalTo(labelBest.intrinsicContentSize.height)
        }
        
        let horizontalStackView3 = UIStackView()
        horizontalStackView3.axis = .horizontal
        horizontalStackView3.distribution = .fillEqually
        horizontalStackView3.addArrangedSubview(seT1000)
        horizontalStackView3.addArrangedSubview(seT500)
        horizontalStackView3.addArrangedSubview(seT200)
        mainStackView.addArrangedSubview(horizontalStackView3)
        
        let horizontalStackView4 = UIStackView()
        horizontalStackView4.axis = .horizontal
        horizontalStackView4.distribution = .fillEqually
        horizontalStackView4.addArrangedSubview(seSpeed)
        horizontalStackView4.addArrangedSubview(seStroke)
        horizontalStackView4.addArrangedSubview(seForce)
        mainStackView.addArrangedSubview(horizontalStackView4)
        
        scrollView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.containerView)
        }
    }
    
    private lazy var labelAverage: AppUILabel! = {
        let label = AppUILabel()
        label.text = getString("training_sum_average").uppercased()
        label.textAlignment = .center
        label.textColor = Colors.colorPrimary
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        label.backgroundColor = Colors.colorQrey
        
        return label
    }()
    
    private lazy var labelBest: AppUILabel! = {
        let label = AppUILabel()
        label.text = getString("training_sum_best").uppercased()
        label.textAlignment = .center
        label.textColor = Colors.colorPrimary
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        label.backgroundColor = Colors.colorQrey
        
        return label
    }()
    
    private lazy var seT1000Av: TrainingSET1000Av! = {
        let se = TrainingSET1000Av(position: self.position!)
        
        return se
    }()
    
    private lazy var seT500Av: TrainingSET500Av! = {
        let se = TrainingSET500Av(position: self.position!)
        
        return se
    }()
    
    private lazy var seT200Av: TrainingSET200Av! = {
        let se = TrainingSET200Av(position: self.position!)
        
        return se
    }()
    
    private lazy var seSpeedAv: TrainingSESpeedAv! = {
        let se = TrainingSESpeedAv(position: self.position!)
        
        return se
    }()
    
    private lazy var seStrokeAv: TrainingSEStrokesAv! = {
        let se = TrainingSEStrokesAv(position: self.position!)
        
        return se
    }()
    
    private lazy var seForceAv: TrainingSEForceAv! = {
        let se = TrainingSEForceAv(position: self.position!)
        
        return se
    }()
    
    private lazy var seT1000: TrainingSET1000! = {
        let se = TrainingSET1000(position: self.position!)
        
        return se
    }()
    
    private lazy var seT500: TrainingSET500! = {
        let se = TrainingSET500(position: self.position!)
        
        return se
    }()
    
    private lazy var seT200: TrainingSET200! = {
        let se = TrainingSET200(position: self.position!)
        
        return se
    }()
    
    private lazy var seSpeed: TrainingSESpeed! = {
        let se = TrainingSESpeed(position: self.position!)
        
        return se
    }()
    
    private lazy var seStroke: TrainingSEStroke! = {
        let se = TrainingSEStroke(position: self.position!)
        
        return se
    }()
    
    private lazy var seForce: TrainingSEForce! = {
        let se = TrainingSEForce(position: self.position!)
        
        return se
    }()
    
}
