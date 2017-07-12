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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: properties
    private var welcomeViewController: WelcomeViewController?
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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initColors()
        initMainWindow()
        initKeyboardManager()
        deleteOldData()
        initCrashlytics(appdelegate: self)
        registerForPushNotifications()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func initMainWindow() {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = Colors.colorPrimary
        
        var viewController: UIViewController
        
        if UserManager.sharedInstance.getUser() != nil {
            UserManager.sharedInstance.isQuickStart = false
            
            viewController = MainTabViewController()
            welcomeViewController = nil
        } else {
            viewController = WelcomeViewController()
            welcomeViewController = viewController as! WelcomeViewController
        }
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    private func initKeyboardManager() {
        IQKeyboardManager.sharedManager().enable = true
    }
    
    private func deleteOldData() {
        DispatchQueue.global().async {
            AppSql.deleteOldData()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        if let vc = welcomeViewController {
            vc.resetFields()
            logoutSocial()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
        
        print("APNs device token: \(deviceTokenString)")
        
        PushNotificationHelper.setToken(pushToken: deviceTokenString)
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
    
    func logoutSocial() {
        FBSDKLoginManager().logOut()
        GIDSignIn.sharedInstance().signOut()
    }
    
    private func initColors() {
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

