//
//  FeedCoordinator.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit
import FeedKit
import SafariServices
import RxSwift
import RealmSwift

class FeedListCoordinator: Coordinator {
    
    weak var appCoordinator: AppCoordinatorProtocol!
    weak var navigationController: UINavigationController!
    var feedItems: [FeedModel]!
    private var bag:DisposeBag? = nil
    var provider = NewsProvider()
    
    init(navigationController: UINavigationController, item: NewsProvider) {
        
        self.navigationController = navigationController
        self.provider = item
        
    }
    
    func start() {
        bag = DisposeBag()
 
        if let vc = R.storyboard.main.feedListVC() {
            let realm = try! Realm()
  
            let viewModel = FeedListViewModel(realm: realm, provider: provider)
            vc.viewModel = viewModel
            self.navigationController.pushViewController(vc, animated: true)
            
            //display full screen detailed feed when selected
            viewModel.feedSelected
                .subscribe(onNext: { item in
                    
                    self.appCoordinator.startDetailFeed(with: item, on: self.navigationController)
                    
                }).disposed(by: bag!)
            
        }

    }
    
}
