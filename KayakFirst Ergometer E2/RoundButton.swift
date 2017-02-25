//
//  RoundButton.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    //MARK: properties
    private var color: UIColor {
        didSet {
            backgroundColor = color
        }
    }
    private var image: UIImage {
        didSet {
            //setImage(image, for: .normal)
        }
    }
    
    //MARK: init
    init(radius: CGFloat, image: UIImage, color: UIColor) {
        self.color = color
        self.image = image
        
        super.init(frame: CGRect(x: 0, y: 0, width: radius, height: radius))
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        let height = self.frame.height
        self.layer.cornerRadius = height / 2
        
        return CGSize(width: self.frame.width, height: height)
    }
    
    //MARK: init view
    private func initView() {
        self.layer.masksToBounds = true
        
        backgroundColor = color
        
        setImage(image, for: .normal)
    }
}
