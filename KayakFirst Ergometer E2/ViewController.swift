//
//  ViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var separatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = getColor(Colors.colorPrimary)
        separatorView.backgroundColor = getColor(Colors.colorInactive)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

