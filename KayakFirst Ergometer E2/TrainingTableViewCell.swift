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
    
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.colorTransparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func initData(data: SumTraining?) {
        labelStart.text = data?.formattedStartTime
        labelDuration.text = data?.formattedDuration
        labelDistance.text = data?.formattedDistance
        
        var imageEnviromentType: UIImage?
        
        if let dataValue = data {
            switch dataValue.trainingList![0].trainingEnvironmentType {
            case TrainingEnvironmentType.ergometer:
                imageEnviromentType = UIImage(named: "lightBulb")
            case TrainingEnvironmentType.outdoor:
                imageEnviromentType = UIImage(named: "sun")
            default:
                break
            }
            
            imgErgoOutdoor.image = imageEnviromentType
        }
    }
    
    //MARK: init view
    override func initView() -> UIView {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(imgErgoOutdoor)
        stackView.addArrangedSubview(labelStart)
        stackView.addArrangedSubview(labelDuration)
        stackView.addArrangedSubview(labelDistance)
        stackView.addArrangedSubview(imageViewGraph)
        
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
    
    private lazy var imageViewGraph: UIImageView! = {
        let imageView = UIImageView()
        let image = UIImage(named: "chart_dia")
        
        imageView.image = image
        imageView.setImageTint(color: Colors.colorAccent)
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var imgErgoOutdoor: UIImageView! = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
}
