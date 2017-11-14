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
    private var bag: DisposeBag? = nil
    
    init(navigationController: UINavigationController, item: FeedModel) {
        
        self.navigationController = navigationController
        self.feedItem = item

    }
    
    func start() {
        bag = DisposeBag()

        if let vc = R.storyboard.main.detailFeedVC() {
            let viewModel = DetailFeedViewModel(item: self.feedItem)
            vc.viewModel = viewModel
            self.navigationController.pushViewController(vc, animated: true)
            
            //open feed link in Safari 
            viewModel.openURL
                .subscribe(onNext: { item in
                    
                    UIApplication.shared.open(item, options: [:])
                    
                }).disposed(by: bag!)
        }
    }
}

