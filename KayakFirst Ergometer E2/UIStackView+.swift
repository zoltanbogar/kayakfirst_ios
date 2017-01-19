//
//  UIStackView+.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 19..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import SnapKit

extension UIStackView {
    
    func addVerticalSpacing(spacing: CGFloat) {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(spacing)
        }
        addArrangedSubview(view)
    }
    
    func addHorizontalSpacing(spacing: CGFloat) {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.equalTo(spacing)
        }
        addArrangedSubview(view)
    }
    
    func fillSpacing(axis: UILayoutConstraintAxis) {
        let view = UIView()
        view.setContentHuggingPriority(500, for: axis)
        addArrangedSubview(view)
    }
    
    func addVerticalSeparator(color: UIColor, thickness: Int) {
        let view = UIView()
        addArrangedSubview(view)
        view.backgroundColor = color
        view.snp.makeConstraints { make in
            make.height.equalTo(thickness)
        }
    }
    
    func addHorizontalSeparator(color: UIColor, thickness: Int) {
        let view = UIView()
        addArrangedSubview(view)
        view.backgroundColor = color
        view.snp.makeConstraints { make in
            make.width.equalTo(thickness)
        }
    }
    
}
