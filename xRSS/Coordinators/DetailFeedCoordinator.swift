//
//  DetailFeedCoordinator.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/30/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit
import FeedKit
import SafariServices
import RxSwift

class DetailFeedCoordinator: Coordinator {
    
    weak var appCoordinator: AppCoordinatorProtocol!
    weak var navigationController: UINavigationController!
    var feedItem: FeedModel!
    var bag = DisposeBag()
    
    init(navigationController: UINavigationController, item: FeedModel) {
        
        self.navigationController = navigationController
        self.feedItem = item

    }
    
    func start() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailFeedVC") as? DetailFeedViewController {
            let viewModel = DetailFeedViewModel(item: self.feedItem)
            vc.viewModel = viewModel
            self.navigationController.pushViewController(vc, animated: true)
            
            viewModel.openURL
                .subscribe(onNext: { item in
                    
                    UIApplication.shared.open(item, options: [:])
                    
                }).disposed(by: bag)
            
        }
        
    }
        
}

