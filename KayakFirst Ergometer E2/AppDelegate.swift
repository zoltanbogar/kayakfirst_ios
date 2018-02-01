//
//  AppDelegate.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKLoginKit
import Google
import UserNotifications
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: properties
    static var versionString: String {
        get {
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return version
            } else {
                return "1.0"
            }
        }
    }
    static var buildString: String {
        get {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                return build
            } else {
                return "1"
            }
        }
    }

    var window: UIWindow?
    
    var alamofireManager = SessionManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureAlamofire()
        
        startMainWindow()
        initColors()
        initKeyboardManager()
        deleteOldData()
        initCrashlytics(appdelegate: self)
        registerForPushNotifications()
        
        downloadMessage()
        
        checkSystem()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func startMainWindow() {
        if (window == nil) {
            window = UIWindow.init(frame: UIScreen.main.bounds)
        }
        
        var viewController: UIViewController
        
        let userManager = UserManager.sharedInstance
        let isUserLoggedIn = userManager.getUser() != nil || userManager.isQuickStart
        
        if isUserLoggedIn {
            viewController = MainTabViewController()
        } else {
            viewController = WelcomeViewController()
        }
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    private func initKeyboardManager() {
        IQKeyboardManager.sharedManager().enable = true
    }
    
    private func deleteOldData() {
        TrainingManager.sharedInstance.deleteOldData()
    }
    
    private func downloadMessage() {
        LogManager.sharedInstance.messageCallback = { data, error in
            showAppMessage(message: data)
        }
        LogManager.sharedInstance.versionCallback = { data, error in
            UpdateDialog.showUpdateDialog(actualVersionCode: data)
        }
        LogManager.sharedInstance.getMessage()
    }
    
    private func checkSystem() {
        DispatchQueue.global().async {
            SystemInfoDbLoader.sharedInstance.deleteOldData()
            LogObjectDbLoader.sharedInstance.deleteOldData()
            
            LogManager.sharedInstance.checkSystemInfo()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        let currentVc = self.window?.currentViewController()
        
        if let vc = currentVc {
            if vc is BaseVcProtocol {
                (vc as! BaseVcProtocol).onPause()
            }
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        startUploadTimer()
        
        let currentVc = self.window?.currentViewController()
        
        if let vc = currentVc {
            if vc is BaseVcProtocol {
                (vc as! BaseVcProtocol).onResume()
            }
        }
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        startUploadTimer()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: push notifications
    func registerForPushNotifications() {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
                guard granted else { return }
                self.getNotificationSettings()
            }
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        log("PUSH_MESSAGE", "token: \(deviceTokenString)")
        
        PushNotificationHelper.setToken(pushToken: deviceTokenString)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        handlePushMessage(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        handlePushMessage(userInfo: userInfo)
    }
    
    private func handlePushMessage(userInfo: [AnyHashable : Any]) {
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSString {
                log("PUSH_MESSAGE", "message: \(alert)")
                
                ErrorDialog(errorString: alert as String).show()
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "fbxxxxx" {
            return FBSDKApplicationDelegate.sharedInstance().application(
                app,
                open: url,
                sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }else if url.scheme == "com.googleusercontent.apps.*"
        {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:  options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
        
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    private func startUploadTimer() {
        UploadTimer.startTimer(forceStart: true)
    }
    
    private func configureAlamofire() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120 // in seconds
        configuration.timeoutIntervalForResource = 120 // in seconds
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    private func initColors() {
        window?.backgroundColor = Colors.colorPrimary
        
        UITabBar.appearance().tintColor = Colors.colorAccent
        UITabBar.appearance().barTintColor = Colors.colorPrimary
        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = Colors.colorWhite
        }
        
        UINavigationBar.appearance().tintColor = Colors.colorWhite
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:Colors.colorWhite]
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Colors.colorPrimary], for: UIControlState.selected)
        UITextField.appearance().tintColor = Colors.colorAccent
        UITextView.appearance().tintColor = Colors.colorAccent
    }
}

