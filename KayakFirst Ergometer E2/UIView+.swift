//
//  UIView+.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

extension UIView {
    //MARK: blur
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.8
        self.addSubview(blurEffectView)
    }
    
    //MARK: drag drop
    func getSnapshotView() -> UIView {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        let snapshot : UIView = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.setAppShadow()
        return snapshot
    }
    
    func isDragDropEnter(superView: UIView, gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.frame.contains(gestureRecognizer.location(in: superView))
    }
    
    //MARK: shadow
    func setAppShadow() {
        layer.shadowOffset = CGSize(width: 2.0, height: 1.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
        clipsToBounds = false
    }
    
    //MARK: border
    func showAppBorder() {
        layer.borderWidth = dashboardDividerWidth
        layer.borderColor = Colors.colorDashBoardDivider.cgColor
    }
    
    //MARK: gradient
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) -> Void {
        self.layer.addSublayer(getGradient(withColours: colours, gradientOrientation: orientation))
    }
    
    func getGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        return gradient
    }
}

//MARK: gradient helper
typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    case verticalPortrait
    case verticalLandscape
    
    var startPoint : CGPoint {
        get { return points.startPoint }
    }
    
    var endPoint : CGPoint {
        get { return points.endPoint }
    }
    
    var points : GradientPoints {
        get {
            switch(self) {
            case .topRightBottomLeft:
                return (CGPoint.init(x: 0.0,y: 1.0), CGPoint.init(x: 1.0,y: 0.0))
            case .topLeftBottomRight:
                return (CGPoint.init(x: 0.0,y: 0.0), CGPoint.init(x: 1,y: 1))
            case .horizontal:
                return (CGPoint.init(x: 0.0,y: 0.5), CGPoint.init(x: 1.0,y: 0.5))
            case .vertical:
                return (CGPoint.init(x: 0.0,y: 0.0), CGPoint.init(x: 0.0,y: 1.0))
            case .verticalPortrait:
                return (CGPoint.init(x: 0.0,y: 0.25), CGPoint.init(x: 0.0,y: 0.45))
            case .verticalLandscape:
                return (CGPoint.init(x: 0.0,y: 0.25), CGPoint.init(x: 0.0,y: 0.60))
            }
        }
    }
}


