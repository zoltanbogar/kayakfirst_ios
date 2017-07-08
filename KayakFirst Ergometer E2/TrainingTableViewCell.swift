//
//  TrainingTableViewCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TrainingTablewViewCell: AppUITableViewCell<SumTraining> {
    
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
        Plan.setTypeIcon(plan: sumTraining?.planTraining, imageView: imgPlanType)
        
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
        stackView.addArrangedSubview(imgPlanType)
        stackView.addArrangedSubview(labelStart)
        stackView.addArrangedSubview(labelDuration)
        stackView.addArrangedSubview(labelDistance)
        //TODO: it should be #viewGraph
        stackView.addArrangedSubview(imageViewGraph)
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
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var labelDuration: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var labelDistance: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var imgPlanType: UIImageView! = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var viewGraph: UIView! = {
        let view = UIView()
        
        /*view.addSubview(self.imageViewGraph)
        self.imageViewGraph.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }*/
        
        return view
    }()
    
    private lazy var imageViewGraph: UIImageView! = {
        let imageView = UIImageView()
        let image = UIImage(named: "chart_dia")
        
        imageView.image = image
        imageView.setImageTint(color: Colors.colorAccent)
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
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
