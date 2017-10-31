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
    var bag = DisposeBag()
    
    init(navigationController: UINavigationController, items: [FeedModel]) {
        
        self.navigationController = navigationController
        self.feedItems = items
        
    }
    
    func start() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "FeedListVC") as? FeedListViewController {
            let realm = try! Realm()
            let viewModel = FeedListViewModel(realm: realm)
            vc.viewModel = viewModel
            self.navigationController.pushViewController(vc, animated: true)
            
            viewModel.feedSelected
                .subscribe(onNext: { item in
                    
                    self.appCoordinator.startDetailFeed(with: item, on: self.navigationController)
                    
                }).disposed(by: bag)
            
        }

    }
    
}
