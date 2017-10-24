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

struct NewsProvider {
    
    var title = ""
    var url = ""
    
    init( _title: String, _url: String){
        
        title = _title
        url = _url
        
    }
}

class ListViewModel {
    
    var bag = DisposeBag()
    
    let newsProviders = Variable<[NewsProvider]>([
        NewsProvider( _title: "CITYDOG.BY", _url: "https://citydog.by/rss/"),
        NewsProvider( _title: "KAKTUTZHIT.BY", _url: "https://feeds.feedburner.com/kaktutzhit"),
        NewsProvider( _title: "ONLINER.BY", _url: "https://people.onliner.by/feed")])
    
    let newsProviderSelected = PublishSubject<NewsProvider>()
 
    init() {
//        newsProviderSelected
//            .subscribe(onNext: { item in
//                let feedURL = URL(string: item.url)
//                let parser = FeedParser(URL: feedURL!)
//
//                parser?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
//
//                    switch result {
//
//                    case let .atom(feed):   print(feed.entries)
//                    case let .rss(feed):   print(feed.items)     // Really Simple Syndication Feed Model
//                    case let .json(feed):    print(feed.items)   // JSON Feed Model
//                    case let .failure(error):print(error.localizedDescription)
//
//                    }
//                    DispatchQueue.main.async {
//                        // ..and update the UI
//                    }
//                }
//
//            })
//        .disposed(by: bag)
    }
    
}
