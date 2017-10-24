//
//  ListCoordinator.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit
import RxSwift
import FeedKit

class ListCoordinator: Coordinator {
    
    weak var appCoordinator: Coordinator!
    weak var navigationController: UINavigationController!
    var bag = DisposeBag()
    
    init (navigationController: UINavigationController) {
        
        self.navigationController = navigationController
        
    }
    
    func start() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ListVC") as? ListViewController {
            let viewModel = ListViewModel()
            vc.viewModel = viewModel
            self.navigationController.pushViewController(vc, animated: true)
            
            viewModel.newsProviderSelected
                .flatMap { newsProvider -> Observable<[FeedKit.RSSFeedItem]> in
            
                    RSSService.shared.getFeed(forURL: newsProvider.url)
                
                }.subscribe(onNext: { items in
                    print(items)
                })
                .disposed(by: bag)
            
            
        }
        
        
        
        
    }
    
    
    
}
