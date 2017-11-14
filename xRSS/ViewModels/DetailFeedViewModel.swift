//
//  DetailFeedViewModel.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/30/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import FeedKit
import RxSwift
import RxCocoa
import Alamofire

class DetailFeedViewModel: DetailFeedViewModelProtocol {
    
    var title = Variable<String>("")
    var feedDescription = Variable<String>("")
    var url = Variable<URL>(URL(string:"https://www.google.by")!)
    var imageURL = Variable<URL>(URL(string: "https://google.by")!)
    var newsFeedTitle = Variable<String>("")
    
    private var bag: DisposeBag? = nil
    
    //output to Coordinator
    var openURL = PublishSubject<URL>()
    
    init(item: FeedModel){
        
        bag = DisposeBag()
        title.value = item.title
        feedDescription.value = item.feedDescription
        url.value = URL(string: item.url)!
        imageURL.value = URL(string: item.imageURL)!
        newsFeedTitle.value = item.newsProviderTitle
        
    }
    
    func openUrl() {
        self.openURL.onNext(self.url.value)
    }
    
}
