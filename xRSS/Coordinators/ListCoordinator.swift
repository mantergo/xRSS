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
    
    weak var appCoordinator: AppCoordinatorProtocol!
    var navigationController: UINavigationController!
    var indicator = ActivityIndicator()
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
            
            //open feedlist when newsprovider selected
            viewModel.newsProviderSelected
            .observeOn(main)
                .subscribe(onNext: { [weak self] provider in
                    
                    if let navig = self?.navigationController {
                    self?.appCoordinator.startFeedList(with: provider, on: navig)
                    }
                }).disposed(by: bag)
            
            //send error to main coordinator
            viewModel.errorResult
                .observeOn(main)
                .subscribe(onNext: { [weak self] (errorMsg, type) in
                    
                    self?.appCoordinator.handleResult(message: errorMsg, type: false)
                    
                }).disposed(by: bag)
        }
    }
}
