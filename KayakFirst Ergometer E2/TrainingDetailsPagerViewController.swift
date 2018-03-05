//
//  TrainingDetailsPagerViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

func startTrainingDetailsPagerVc(navController: UINavigationController, sumTrainings: [SumTraining]?, position: Int) {
    let viewController = TrainingDetailsPagerViewController()
    viewController.sumTrainings = sumTrainings
    viewController.position = position
    navController.pushViewController(viewController, animated: true)
}

class TrainingDetailsPagerViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var sumTrainings: [SumTraining]?
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
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        setFirstViewController()
        
        initActionbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WindowHelper.keepScreenOn(isOn: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        WindowHelper.keepScreenOn(isOn: false)
    }
    
    private func initActionbar() {
        self.navigationItem.setLeftBarButtonItems([btnBack], animated: true)
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 14.0)!];
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
        if let sumTrainingsValue = sumTrainings {
            trainingViewControllers = [TrainingDetailsViewController]()
            for i in 0..<sumTrainingsValue.count {
                let controller = TrainingDetailsViewController()
                controller.sumTraining = sumTrainingsValue[i]
                controller.position = i
                controller.maxPosition = sumTrainingsValue.count
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
        btnTrainingType.image = getTrainingTypeIcon(trainingEnvType: viewController.sumTraining?.trainingEnvironmentType)
        
        if viewController.sumTraining?.planTrainingType != nil {
            btnPlanType.image = getPlanTypeIconSmall(planType: viewController.sumTraining!.planTrainingType!)?.withRenderingMode(.alwaysOriginal)
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
