//
//  FeedCoordinator.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit
import FeedKit

class FeedListCoordinator: Coordinator {
    
    weak var appCoordinator: AppCoordinator!
    weak var navigationController: UINavigationController!
    var feedItems: [FeedKit.RSSFeedItem]!
    
    
    init(navigationController: UINavigationController, items: [FeedKit.RSSFeedItem]) {
        
        self.navigationController = navigationController
        self.feedItems = items
        
    }
    
    func start() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "FeedListVC") as? FeedListViewController {
            let viewModel = FeedListViewModel(items: self.feedItems)
            vc.viewModel = viewModel
            self.navigationController.pushViewController(vc, animated: true)
            
        }

    }
    
}
