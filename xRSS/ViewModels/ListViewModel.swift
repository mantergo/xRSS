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
import AlamofireImage
import RxAlamofire



protocol ListVM {
    
    var bag: DisposeBag { get set }
    var indicator: ActivityIndicator { get set }
    var newsProviderSelected: PublishSubject<NewsProvider> { get set }
    var feedReady: PublishSubject<[FeedViewModel]> { get set }
    var errorResult: PublishSubject<(String, Bool)> { get set }
    
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
            
            .flatMap { newsProvider -> Observable<[FeedKit.RSSFeedItem]> in
                
                RSSService.shared.getFeed(forURL: newsProvider.url)
                    //.delay(2.0, scheduler: MainScheduler.asyncInstance)
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
                    
//                    requestData(.get, URL(string: (item.media?.mediaThumbnails![0].attributes?.url!)!)!)
//                        .observeOn(serial)
//                        .subscribe (onNext: { ( _, data) in
                    var imageUrl = URL(string: "")
                    if let media = item.media?.mediaThumbnails {
                        imageUrl = URL(string:(media[0].attributes?.url)!)
                    }
                    else {
                        imageUrl = URL(string: (item.media?.mediaContents![0].attributes?.url)!)
                    }
                    
                    feedArray.append(FeedViewModel(_title: item.title!, _description: item.description!, _url: item.link!, _date: item.pubDate!, _image:
                        imageUrl!))
                            
//                        }
//                        ).disposed(by: self.bag)
//
                    
                    
                }
                return Observable.just(feedArray)
            }
            .subscribe(onNext: {[weak self] items in
                self?.feedReady.onNext(items)
            })
            .disposed(by: bag)
    }
    
}
