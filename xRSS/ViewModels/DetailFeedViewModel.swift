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

protocol DetailFeedVM {
    
    var title: Variable<String> { get set }
    var feedDescription: Variable<String> { get set }
    var url: Variable<URL> { get set }
    var imageURL: Variable<URL> { get set }
    
    var newsFeedTitle: Variable<String> { get set }
    
    var openButton: PublishSubject<Void> { get set }
    var openURL: PublishSubject<URL> { get set }
    
}

class DetailFeedViewModel: DetailFeedVM {

    var title = Variable<String>("")
    var feedDescription = Variable<String>("")
    var url = Variable<URL>(URL(string:"https://www.google.by")!)
    var imageURL = Variable<URL>(URL(string: "https://google.by")!)
    var newsFeedTitle = Variable<String>("")
    
    var bag = DisposeBag()
    
    //input from VC
    var openButton = PublishSubject<Void>()
    
    //output to Coordinator
    var openURL = PublishSubject<URL>()
    
    init(item: FeedModel){
        
        title.value = item.title
        feedDescription.value = item.feedDescription
        url.value = URL(string: item.url)!
        imageURL.value = URL(string: item.imageURL)!
        newsFeedTitle.value = item.newsProviderTitle
        
        openButton
            .subscribe( onNext: { [unowned self] in
                self.openURL.onNext(self.url.value)
            }).disposed(by: bag)
    
    }
    
}
