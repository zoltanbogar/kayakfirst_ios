//
//  OrientationNavController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 12..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class OrientationNavController: UINavigationController {
    
    //MARK: properties
    var rotationEnabled: Bool {
        return true
    }
    
    //MARK: lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !rotationEnabled {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if rotationEnabled {
            return UIInterfaceOrientationMask.all
        } else {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        /*if rotationEnabled {
            return UIInterfaceOrientation.portrait
        } else {
            return UIInterfaceOrientation.portrait
        }*/
        return UIInterfaceOrientation.portrait
    }
    
    override var shouldAutorotate: Bool {
        return rotationEnabled
    }
    
}
