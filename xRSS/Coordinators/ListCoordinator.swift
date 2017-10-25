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
    
    weak var appCoordinator: AppCoordinator!
    weak var navigationController: UINavigationController!
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
            
            viewModel.newsProviderSelected
                .observeOn(serial)
                //.trackActivity(self.indicator)
                .flatMap { newsProvider -> Observable<[FeedKit.RSSFeedItem]> in
            
                    RSSService.shared.getFeed(forURL: newsProvider.url)
                       // .delay(2.0, scheduler: MainScheduler.asyncInstance)
                        .trackActivity(self.indicator)
                        .catchError({[weak self] (error) -> Observable<[FeedKit.RSSFeedItem]> in
                            print(error)
                            self?.appCoordinator.handleResult(message: error.localizedDescription, type: false)
                            return Observable.create{ observer in
                                observer.on(.next([]))
                                return Disposables.create {
                                    print("disposed")
                                }
                            }
                        })
                }
                .observeOn(main)
                .flatMap{ (items) -> Observable<[FeedViewModel]> in
                    var feedArray = [FeedViewModel]()
                    for item in items {
                        feedArray.append(FeedViewModel(_title: item.title!, _description: item.description!, _url: item.link!))
                    }
                    return Observable.just(feedArray)
                }
                .subscribe(onNext: {[weak self] items in
                    self?.appCoordinator.startFeedList(with: items, on: (self?.navigationController)!)
                })
                .disposed(by: bag)
            
            
        }
        
        
        
        
    }
    
    
    
}
