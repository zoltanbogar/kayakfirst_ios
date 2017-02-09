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
    private var createTrainingList: CreateTrainingList?
    private var mainView: UIView?
    
    //MARK: init
    init(frame: CGRect, position: Int, createTrainingList: CreateTrainingList) {
        super.init(frame: frame)
        mainView = UIView(frame: frame)
        
        self.position = position
        self.createTrainingList = createTrainingList
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: views
    private func initView() {
        let mainStackView = UIStackView(frame: mainView!.bounds)
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(labelAverage)
        
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
        horizontalStackView2.snp.makeConstraints { make in
            make.width.equalTo(mainStackView)
        }
        
        mainStackView.addArrangedSubview(labelBest)
        
        let horizontalStackView3 = UIStackView()
        horizontalStackView3.axis = .horizontal
        horizontalStackView3.distribution = .fillEqually
        horizontalStackView3.addArrangedSubview(seT1000)
        horizontalStackView3.addArrangedSubview(seT500)
        horizontalStackView3.addArrangedSubview(seT200)
        mainStackView.addArrangedSubview(horizontalStackView3)
        horizontalStackView3.snp.makeConstraints { make in
            make.width.equalTo(mainStackView)
        }
        
        let horizontalStackView4 = UIStackView()
        horizontalStackView4.axis = .horizontal
        horizontalStackView4.distribution = .fillEqually
        horizontalStackView4.addArrangedSubview(seSpeed)
        horizontalStackView4.addArrangedSubview(seStroke)
        horizontalStackView4.addArrangedSubview(seForce)
        mainStackView.addArrangedSubview(horizontalStackView4)
        horizontalStackView4.snp.makeConstraints { make in
            make.width.equalTo(mainStackView)
        }
    }
    
    private lazy var labelAverage: AppUILabel! = {
        let label = AppUILabel()
        label.text = getString("training_sum_average")
        
        return label
    }()
    
    private lazy var labelBest: AppUILabel! = {
        let label = AppUILabel()
        label.text = getString("training_sum_best")
        
        return label
    }()
    
    private lazy var seT1000Av: TrainingSET1000Av! = {
        let se = TrainingSET1000Av(position: self.position!, createTrainingList: self.createTrainingList!)
        
        return se
    }()
    
    private lazy var seT500Av: TrainingSET500Av! = {
        let se = TrainingSET500Av(position: self.position!, createTrainingList: self.createTrainingList!)
        
        return se
    }()
    
    private lazy var seT200Av: TrainingSET200Av! = {
        let se = TrainingSET200Av(position: self.position!, createTrainingList: self.createTrainingList!)
        
        return se
    }()
    
    private lazy var seSpeedAv: TrainingSESpeedAv! = {
        let se = TrainingSESpeedAv(position: self.position!, createTrainingList: self.createTrainingList!)
        
        return se
    }()
    
    private lazy var seStrokeAv: TrainingSEStrokesAv! = {
        let se = TrainingSEStrokesAv(position: self.position!, createTrainingList: self.createTrainingList!)
        
        return se
    }()
    
    private lazy var seForceAv: TrainingSEForceAv! = {
        let se = TrainingSEForceAv(position: self.position!, createTrainingList: self.createTrainingList!)
        
        return se
    }()
    
    private lazy var seT1000: TrainingSET1000! = {
        let se = TrainingSET1000(position: self.position!, createTrainingList: self.createTrainingList!)
        
        return se
    }()
    
    private lazy var seT500: TrainingSET500! = {
        let se = TrainingSET500(position: self.position!, createTrainingList: self.createTrainingList!)
        
        return se
    }()
    
    private lazy var seT200: TrainingSET200! = {
        let se = TrainingSET200(position: self.position!, createTrainingList: self.createTrainingList!)
        
        return se
    }()
    
    private lazy var seSpeed: TrainingSESpeed! = {
        let se = TrainingSESpeed(position: self.position!, createTrainingList: self.createTrainingList!)
        
        return se
    }()
    
    private lazy var seStroke: TrainingSEStroke! = {
        let se = TrainingSEStroke(position: self.position!, createTrainingList: self.createTrainingList!)
        
        return se
    }()
    
    private lazy var seForce: TrainingSEForce! = {
        let se = TrainingSEForce(position: self.position!, createTrainingList: self.createTrainingList!)
        
        return se
    }()
    
}
