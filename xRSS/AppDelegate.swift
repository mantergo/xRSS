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
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
        
        let branch: Branch = Branch.getInstance()
        branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
            if error == nil {
                //check if it is init or deeplink 
                let castedParams = params as! [String: AnyObject]
                if((castedParams["~creation_source"]) != nil){
                    print("params: %@", params as? [String: AnyObject] ?? {})
                    self.appCoordinator.start(with: (params as? [String: AnyObject])!)
                }
            }
        })
        Twitter.sharedInstance().start(withConsumerKey:"PvJCV1X0iU2lhLDOlom5ztbud", consumerSecret:"uQ4iUzcnoSF4RstoDKoGS875ikxMFnrgXfj7dhcvAtEZFFiPVk")
        
        DBService.shared.cleanOutdatedFeed()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }
    
    
    // Respond to URI scheme links
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // pass the url to the handle deep link call
        Branch.getInstance().application(application,
                                                             open: url,
                                                             sourceApplication: sourceApplication,
                                                             annotation: annotation
        )
        return true
    }
    
}

