//
//  ListViewModel.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import RxSwift
import FeedKit

protocol ListVM {
    
    var bag:DisposeBag { get set }
    var indicator:ActivityIndicator { get set }
    var newsProviderSelected:PublishSubject<NewsProvider> { get set }
    var feedReady:PublishSubject<[FeedViewModel]> { get set }
    var errorResult:PublishSubject<(String, Bool)> { get set }
    
}


class ListViewModel: ListVM {
    
    
    var bag = DisposeBag()
    var indicator = ActivityIndicator()

    //input
    var newsProviderSelected = PublishSubject<NewsProvider>()
    //output
    var feedReady = PublishSubject<[FeedViewModel]>()
    var errorResult = PublishSubject<(String, Bool)>()
    
    init() {
        
        newsProviderSelected
    
            .observeOn(serial)
            .trackActivity(self.indicator)
            .flatMap { newsProvider -> Observable<[FeedKit.RSSFeedItem]> in
                
                RSSService.shared.getFeed(forURL: newsProvider.url)
                    .trackActivity(self.indicator)
                    .catchError({[weak self] (error) -> Observable<[FeedKit.RSSFeedItem]> in
                        print(error)
                        self?.errorResult.onNext((error.localizedDescription, false))
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
                    feedArray.append(FeedViewModel(_title: item.title!, _description: item.description!, _url: item.link!, _date: item.pubDate!))
                }
                return Observable.just(feedArray)
            }
            .subscribe(onNext: {[weak self] items in
                self?.feedReady.onNext(items)
            })
            .disposed(by: bag)
    }
    
}
