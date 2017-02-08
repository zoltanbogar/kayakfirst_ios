//
//  TrainingDetailsPagerViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TrainingDetailsPagerViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    //MARK: properties
    private var _sumTrainingList: [SumTraining]?
    var sumTrainingList: [SumTraining]? {
        get {
            return _sumTrainingList
        }
        set {
            _sumTrainingList = newValue
            initViewControllers()
        }
    }
    var position: Int?
    private var trainingViewControllers: [UIViewController]?
    
    //MARK: init
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        setFirstViewController()
    }
    
    private func setFirstViewController() {
        setViewControllers([trainingViewControllers![position!]], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = trainingViewControllers?.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard trainingViewControllers!.count > previousIndex else {
            return nil
        }
        
        return trainingViewControllers![previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = trainingViewControllers?.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let viewControllersCount = trainingViewControllers!.count
        
        guard viewControllersCount != nextIndex else {
            return nil
        }
        
        guard viewControllersCount > nextIndex else {
            return nil
        }
        
        return trainingViewControllers![nextIndex]
    }
    
    private func initViewControllers() {
        if let sumTrainings = sumTrainingList {
            trainingViewControllers = [UIViewController]()
            for sumTraining in sumTrainings {
                let controller = TrainingDetailsViewController()
                controller.sumTraining = sumTraining
                trainingViewControllers!.append(controller)
            }
        }
        
    }
    
}
