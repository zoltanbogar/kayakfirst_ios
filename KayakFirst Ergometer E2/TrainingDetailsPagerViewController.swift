//
//  TrainingDetailsPagerViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TrainingDetailsPagerViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var position: Int? {
        didSet {
            initViewControllers()
        }
    }
    private var trainingViewControllers: [TrainingDetailsViewController]?
    
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
        delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        setFirstViewController()
        
        initActionbar()
    }
    
    private func initActionbar() {
        self.navigationItem.setLeftBarButtonItems([btnBack], animated: true)
        showLogoLeft(viewController: self)
    }
    
    private func setFirstViewController() {
        let viewController = trainingViewControllers![position!]
        self.title = viewController.titleString
        initEnvType(viewController: viewController)
        setViewControllers([trainingViewControllers![position!]], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = trainingViewControllers?.index(of: viewController as! TrainingDetailsViewController) else {
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
        guard let viewControllerIndex = trainingViewControllers?.index(of: viewController as! TrainingDetailsViewController) else {
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        let viewController = (pageViewController.viewControllers?[0] as! TrainingDetailsViewController)
        self.title = viewController.titleString
        
        initEnvType(viewController: viewController)
    }
    
    private func initViewControllers() {
        if let sumTrainings = TrainingManager.sharedInstance.detailsTrainingList {
            trainingViewControllers = [TrainingDetailsViewController]()
            for i in 0..<sumTrainings.count {
                let controller = TrainingDetailsViewController()
                controller.sumTraining = sumTrainings[i]
                controller.position = i
                controller.maxPosition = sumTrainings.count
                trainingViewControllers!.append(controller)
            }
        }
    }
    
    //MARK: views
    private lazy var btnTrainingType: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        
        return button
    }()
    
    private lazy var btnPlanType: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        
        return button
    }()
    
    private func initEnvType(viewController: TrainingDetailsViewController) {
        switch viewController.sumTraining!.trainingEnvironmentType! {
        case TrainingEnvironmentType.ergometer:
            btnTrainingType.image = UIImage(named: "lightBulbCopy")
        case TrainingEnvironmentType.outdoor:
            btnTrainingType.image = UIImage(named: "sunCopy")
        default:
            break
        }
        
        if viewController.sumTraining?.planTraining != nil {
            btnPlanType.image = Plan.getTypeIconSmall(plan: viewController.sumTraining!.planTraining)
            self.navigationItem.setRightBarButtonItems([btnTrainingType, btnPlanType], animated: true)
        } else {
            self.navigationItem.setRightBarButtonItems([btnTrainingType], animated: true)
        }
    }
    
    //MARK: tabbaritem
    private lazy var btnBack: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "arrowBack")
        button.target = self
        button.action = #selector(btnBackClick)
        
        return button
    }()
    
    @objc private func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
