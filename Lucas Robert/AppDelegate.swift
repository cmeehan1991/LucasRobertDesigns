//
//  AppDelegate.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 1/13/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UserStatusProtocol {

    let defaults = UserDefaults.standard
    var userStatusModel = UserStatusModel()
    var window: UIWindow?
    var centerContainer: MMDrawerController!
    

    func itemsDownloaded(status: Bool, userID: String) {
        self.defaults.set(status, forKey: "IS_LOGGED_IN")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Check if the user is logged in online first
        self.userStatusModel.delegate = self
        self.userStatusModel.downloadItems()
        
        _ = self.window!.rootViewController
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let centerViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navigationViewController = mainStoryboard.instantiateViewController(withIdentifier: "NavigationDrawerViewController") as! NavigationDrawerViewController
        
        let loginPage = UINavigationController(rootViewController: loginViewController)
        let navigationPage = UINavigationController(rootViewController: navigationViewController)
        let mainPage = UINavigationController(rootViewController: centerViewController)
        
        if defaults.bool(forKey: "IS_LOGGED_IN") == true{
            centerContainer = MMDrawerController(center: mainPage, leftDrawerViewController:navigationPage)
            centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
            centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView

            window!.rootViewController = centerContainer
        }else{
            centerContainer = MMDrawerController(center: loginPage, leftDrawerViewController:nil)
            centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
            centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
            window!.rootViewController = centerContainer
        }
        window!.makeKeyAndVisible()
        
        // Enter PayPal credentials
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentSandbox: "AZ6QhKqZWLgdu23raOjVbNtzgnL05c4q6zQCFgtlt-YePofxepGXdemjs8ngQbJmQyHoTwzZIogolPd1"])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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


}

