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
import RealmSwift

protocol Coordinator {
    
    func start()
    
}

protocol AppCoordinatorProtocol: class, Coordinator {
    
    func start()
    func startList(with navigationController:UINavigationController)
    func startFeedList(with provider: NewsProvider, on navigationController: UINavigationController)
    func startDetailFeed(with feed: FeedModel, on navigationController: UINavigationController)
    func handleResult(message: String, type: Bool)
    
}

class AppCoordinator: AppCoordinatorProtocol {
    
    var window: UIWindow
    var coordinators = [String : Coordinator]()
    var feedItems = Variable<[FeedModel]>([])
    
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
    
    func startFeedList(with provider: NewsProvider, on navigationController: UINavigationController){
        
        var feedListCoordinator: FeedListCoordinator!
        
        feedListCoordinator = FeedListCoordinator(navigationController: navigationController, item: provider)
        feedListCoordinator.appCoordinator = self
        
        coordinators.updateValue(feedListCoordinator, forKey: "feedList")
        feedListCoordinator.start()
        
    }
    
    func startDetailFeed(with feed: FeedModel, on navigationController:UINavigationController){
        
        var detailFeedCoordinator: DetailFeedCoordinator!
        
        detailFeedCoordinator = DetailFeedCoordinator(navigationController: navigationController, item: feed)
        detailFeedCoordinator.appCoordinator = self
        
        coordinators.updateValue(detailFeedCoordinator, forKey: "detailFeed")
       detailFeedCoordinator.start()
        
        
    }
    
    
//show alert with error from VC-s, VM-s, etc.
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
