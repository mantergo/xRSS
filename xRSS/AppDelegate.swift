//
//  AppDelegate.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//


//po Realm.Configuration.defaultConfiguration.fileURL

import UIKit
import RealmSwift
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: Coordinator!
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Twitter.sharedInstance().start(withConsumerKey:"PvJCV1X0iU2lhLDOlom5ztbud", consumerSecret:"uQ4iUzcnoSF4RstoDKoGS875ikxMFnrgXfj7dhcvAtEZFFiPVk")
        
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
        
        DBService.shared.cleanOutdatedFeed()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }
    
    
    
}

