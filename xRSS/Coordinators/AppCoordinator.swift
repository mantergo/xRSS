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
    func start(with params: [String: AnyObject])
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
    
    //start when deeplinked
    func start(with params: [String: AnyObject]){
        
        let navigationController = self.window.rootViewController as! UINavigationController
        
        //create FeedModel from deeplink
        let feedModel = FeedModel(_title: params["$og_title"] as! String, _description: params["$og_description"] as! String, _url: params["$canonical_url"] as! String, _date: Date(), _image: params["$og_image_url"] as! String, _provider: "", _isFavourite: false)
        
        //if news already exists in DB then mark it as favorite
        do {
            let realm = try! Realm()
            if let object = realm.object(ofType: FeedModel.self, forPrimaryKey: params["$canonical_url"] as! String){
                try realm.write {
                    object.isFavourite = true
                }
        //if there is no such news in db then add it and mark as favorite
            } else {
                
                try realm.write {
                    realm.add(feedModel)
                } }
        } catch let error as NSError {
            handleResult(message: error.description, type: false)
        }
        
        //start DetailFeedController with new from deeplink
        startDetailFeed(with: feedModel, on: navigationController)
        
        //leave only only controller with NewsFeedProviders and Controller with news from deeplink
        var navArray = navigationController.viewControllers
        repeat {
            navArray.remove(at: 1)
        } while navArray.count > 2
        
        navigationController.viewControllers = navArray
        //display alert with success
        handleResult(message: "News added to favorites", type: true)
        
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
