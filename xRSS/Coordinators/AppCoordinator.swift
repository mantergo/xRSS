//
//  AppCoordinator.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit
import RxSwift
import FeedKit

@objc protocol Coordinator: class {
    
    func start()
    
}

class AppCoordinator: Coordinator {
    
    var window: UIWindow
    var coordinators = [String : Coordinator]()
    var feedItems = Variable<[FeedViewModel]>([])
    
    init(window: UIWindow)
    {
        
        self.window = window
        self.window.makeKeyAndVisible()
        
    }
    
    func start() {
        
        let navigationController = UINavigationController()
        self.window.rootViewController = navigationController
        startList(with: navigationController)
        
    }
    
    func startList(with navigationController:UINavigationController){
        
        var listCoordinator:ListCoordinator!
        
        if coordinators.index(forKey: "list") == nil {
            listCoordinator = ListCoordinator(navigationController: navigationController)
            listCoordinator.appCoordinator = self
        } else {
            listCoordinator = coordinators["list"] as! ListCoordinator
        }
        
        coordinators.updateValue(listCoordinator, forKey: "list")
        listCoordinator.start()
        
    }
    
    func startFeedList(with feed: [FeedViewModel], on navigationController: UINavigationController){
        
        var feedListCoordinator: FeedListCoordinator!
        
        feedListCoordinator = FeedListCoordinator(navigationController: navigationController, items: feed)
        feedListCoordinator.appCoordinator = self
        
        coordinators.updateValue(feedListCoordinator, forKey: "feedList")
        feedListCoordinator.start()
        
        
    }
    
    
    
    func handleResult(message: String, type: Bool) {
        
        let resultTitle =  type ? "Success" : "Error"
        let resultMessage = message
        let alertController = UIAlertController(title: resultTitle, message: resultMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        alertController.addAction(ok)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    
}
