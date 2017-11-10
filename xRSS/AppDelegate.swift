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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: Coordinator!
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
        
        DBService.shared.cleanOutdatedFeed()
        
        return true
    }
    
}

