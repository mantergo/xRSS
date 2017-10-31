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
    var feedReady: PublishSubject<[FeedModel]> { get set }
    var errorResult: PublishSubject<(String, Bool)> { get set }
    
}


class ListViewModel: ListVM {
    
    var bag = DisposeBag()
    var indicator = ActivityIndicator()
    
    //input
    var newsProviderSelected = PublishSubject<NewsProvider>()
    
    //output
    var feedReady = PublishSubject<[FeedModel]>()
    var errorResult = PublishSubject<(String, Bool)>()
    
    init() {
        
        newsProviderSelected
            
            .observeOn(serial)
            
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
            .flatMap{ (items) -> Observable<[FeedModel]> in
                var feedArray = [FeedModel]()
                for item in items {
                    
                    
                    var imageUrl = URL(string: "")
                    if let media = item.media?.mediaThumbnails {
                        imageUrl = URL(string:(media[0].attributes?.url)!)
                    }
                    else {
                        if let media = item.media?.mediaContents {
                            imageUrl = URL(string:(media[0].attributes?.url)!)
                        } else {
                            
                            imageUrl = URL(string: (item.enclosure?.attributes?.url)!)
                            
                        }
                    }
                    
                    feedArray.append(FeedModel(_title: item.title!, _description: item.description!, _url: item.link!, _date: item.pubDate!, _image:
                        imageUrl!))
                    
                }
                return Observable.just(feedArray)
            }
            .subscribe(onNext: {[weak self] items in
                self?.feedReady.onNext(items)
            })
            .disposed(by: bag)
    }
    
}
