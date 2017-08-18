//
//  TrainingTableViewCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TrainingTablewViewCell: AppUITableViewCell<SumTraining> {
    
    //MARK: constants
    static let fontSize: CGFloat = 15
    
    //MARK: properties
    private let stackView = UIStackView()
    var deleteCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    private var sumTraining: SumTraining?
    
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.colorTransparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func initData(data: SumTraining?) {
        self.sumTraining = data
        labelStart.text = data?.formattedStartTime
        labelDuration.text = data?.formattedDuration
        labelDistance.text = data?.formattedDistance
        
        var imagePlanType: UIImage?
        if sumTraining?.planTraining == nil {
            imagePlanType = UIImage(named: "")
        } else {
            imagePlanType = Plan.getTypeIconSmall(plan: sumTraining?.planTraining)
        }
        btnPlanType.setImage(imagePlanType, for: .normal)
        
        if let envType = data?.trainingEnvironmentType {
            var imageEnviromentType: UIImage?
            switch envType {
            case TrainingEnvironmentType.ergometer:
                imageEnviromentType = UIImage(named: "lightBulbCopy")
            case TrainingEnvironmentType.outdoor:
                imageEnviromentType = UIImage(named: "sunCopy")
            default:
                break
            }
            
            imgErgoOutdoor.image = imageEnviromentType
        }
    }
    
    //MARK: button listener
    @objc private func clickDelete() {
        DeleteTrainingDialog.showDeleteTrainingDialog(viewController: viewController()!, sumTraining: sumTraining!, managerCallback: deleteCallback)
    }
    
    //MARK: init view
    override func initView() -> UIView {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(viewErgoOutdoor)
        stackView.addArrangedSubview(btnPlanType)
        stackView.addArrangedSubview(labelStart)
        stackView.addArrangedSubview(labelDuration)
        stackView.addArrangedSubview(labelDistance)
        stackView.addArrangedSubview(btnGraph)
        stackView.addArrangedSubview(btnDelete)
        
        selectionColor = Colors.colorGrey
        
        return stackView
    }
    
    override func getRowHeight() -> CGFloat {
        return trainingRowHeight
    }
    
    //MARK: views
    private lazy var labelStart: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(fontSize)
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var labelDuration: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(fontSize)
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var labelDistance: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(fontSize)
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var btnPlanType: UIButton! = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var btnGraph: UIButton! = {
        let button = UIButton()
        let image = UIImage(named: "chart_dia")
        
        button.setImage(image?.maskWith(color: Colors.colorAccent), for: .normal)
        
        return button
    }()
    
    private lazy var viewErgoOutdoor: UIView! = {
        let view = UIView()
        
        view.addSubview(self.imgErgoOutdoor)
        self.imgErgoOutdoor.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        return view
    }()
    
    private lazy var imgErgoOutdoor: UIImageView! = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var btnDelete: UIButton! = {
        let button = UIButton()
        let image = UIImage(named: "trashSmall")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(clickDelete), for: .touchUpInside)
        
        return button
    }()
}
