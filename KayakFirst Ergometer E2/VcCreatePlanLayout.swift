//
//  VcCreatePlanLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 28..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcCreatePlanLayout: BaseLayout {
    
    //MARK: constants
    private let btnDeleteRadius: CGFloat = 400
    private let fontSize: CGFloat = 30
    private let fontSizeEdit: CGFloat = 28
    
    override func setView() {
        contentView.addSubview(planElementTableView)
        planElementTableView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(margin05)
            make.top.equalTo(contentView).offset(margin05)
            make.bottom.equalTo(contentView)
            make.width.equalTo(95)
        }
        
        contentView.addSubview(intensityView)
        intensityView.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.right.equalTo(contentView).offset(-margin05)
            make.top.equalTo(planElementTableView)
            make.height.equalTo(55)
        }
        
        contentView.addSubview(keyboardView)
        keyboardView.snp.makeConstraints { (make) in
            make.top.equalTo(intensityView.snp.bottom).offset(margin2)
            make.right.equalTo(intensityView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-128)
            make.left.equalTo(planElementTableView.snp.right).offset(margin05)
        }
    }
    
    func setUIForType(planType: PlanType) {
        var viewToAdd: UIView? = nil
        switch planType {
        case PlanType.distance:
            viewToAdd = distanceView
            break
        case PlanType.time:
            viewToAdd = timeView
            break
        default:
            break
        }
        
        contentView.addSubview(viewToAdd!)
        viewToAdd!.snp.makeConstraints({ (make) in
            make.left.equalTo(keyboardView)
            make.top.equalTo(intensityView)
            make.bottom.equalTo(intensityView)
            make.right.equalTo(intensityView.snp.left).offset(-margin05)
        })
        
        contentView.addSubview(viewDelete)
        viewDelete.snp.makeConstraints { (make) in
            let offset = (btnDeleteRadius / 2)
            make.right.equalTo(contentView).offset(offset)
            make.top.equalTo(contentView).offset(-offset)
            make.height.equalTo(self.btnDeleteRadius)
            make.width.equalTo(self.btnDeleteRadius)
        }
    }
    
    //MARK: views
    lazy var keyboardView: KeyboardNumView! = {
        let keyboardView = KeyboardNumView()
        
        return keyboardView
    }()
    
    lazy var distanceView: UIView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        stackView.addArrangedSubview(self.etDistance)
        
        let labelUnit = BebasUILabel()
        labelUnit.text = UnitHelper.getDistanceUnit()
        labelUnit.font = labelUnit.font.withSize(self.fontSize)
        labelUnit.textAlignment = .center
        labelUnit.snp.makeConstraints({ (make) in
            make.width.equalTo(self.fontSize)
        })
        
        stackView.addArrangedSubview(labelUnit)
        
        return stackView
    }()
    
    lazy var timeView: UIView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        stackView.addArrangedSubview(self.etMinute)
        
        let label = UILabel()
        label.text = ":"
        label.textAlignment = .center
        label.font = label.font.withSize(self.fontSize)
        
        stackView.addArrangedSubview(label)
        
        stackView.addArrangedSubview(self.etSec)
        
        self.etMinute.snp.makeConstraints({ (make) in
            make.width.equalTo(self.etSec)
        })
        
        return stackView
    }()
    
    lazy var intensityView: UIView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        stackView.addArrangedSubview(self.etIntensity)
        
        self.etIntensity.snp.makeConstraints({ (make) in
            make.width.equalTo(self.fontSizeEdit)
        })
        
        let labelPercent = BebasUILabel()
        labelPercent.text = "%"
        labelPercent.textAlignment = .center
        labelPercent.font = labelPercent.font.withSize(20)
        
        labelPercent.snp.makeConstraints({ (make) in
            make.width.equalTo(self.fontSize / 2)
        })
        
        stackView.addArrangedSubview(labelPercent)
        
        return stackView
    }()
    
    lazy var etMinute: PlanEtMinute! = {
        let et = PlanEtMinute()
        et.font = et.font?.withSize(self.fontSizeEdit)
        
        et.hint = getString("plan_hint_minute")
        
        return et
    }()
    
    lazy var etSec: PlanEtSec! = {
        let et = PlanEtSec()
        et.font = et.font?.withSize(self.fontSizeEdit)
        
        et.hint = getString("plan_hint_sec")
        
        return et
    }()
    
    lazy var etIntensity: PlanEtIntensity! = {
        let et = PlanEtIntensity()
        et.font = et.font?.withSize(self.fontSizeEdit)
        
        et.hint = getString("plan_hint_percent")
        
        return et
    }()
    
    lazy var etDistance: PlanEtDistance! = {
        let et = PlanEtDistance()
        et.font = et.font?.withSize(self.fontSizeEdit)
        
        et.hint = UnitHelper.getDistanceUnit()
        
        return et
    }()
    
    lazy var planElementTableView: PlanElementTableView! = {
        let view = PlanElementTableView(view: self.contentView)
        
        return view
    }()
    
    lazy var viewDelete: UIView! = {
        let view = UIView()
        
        view.addSubview(self.backgroundDelete)
        self.backgroundDelete.snp.makeConstraints({ (make) in
            make.center.equalTo(view)
        })
        view.addSubview(self.imgDelete)
        self.imgDelete.snp.makeConstraints({ (make) in
            make.center.equalTo(view).inset(UIEdgeInsetsMake(40, -40, 0, 0))
        })
        
        view.isHidden = true
        
        return view
    }()
    
    lazy var imgDelete: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "trashDropShadow")
        
        return imageView
    }()
    
    lazy var backgroundDelete: RoundButton! = {
        let button = RoundButton(radius: self.btnDeleteRadius, image: UIImage(named: ""), color: Colors.colorTransparent)
        button.applyGradient(withColours: [Colors.colorDeleteEnd, Colors.colorDeleteStart], gradientOrientation: GradientOrientation.topRightBottomLeft)
        
        return button
    }()
    
    //MARK: tabbarItems
    lazy var btnSave: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "save")
        
        return button
    }()
    
    lazy var btnPlay: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "playSmall")
        
        return button
    }()
    
}
