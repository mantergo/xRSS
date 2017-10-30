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

protocol DetailFeedVM {
    
    var title: Variable<String> { get set }
    var description: Variable<String> { get set }
    var url: Variable<URL> { get set }
    var image:Variable<UIImage> { get set }
    
    var openButton: PublishSubject<Void> { get set }
    var openURL: PublishSubject<URL> { get set }
    
}

class DetailFeedViewModel: DetailFeedVM {

    var title = Variable<String>("")
    var description = Variable<String>("")
    var url = Variable<URL>(URL(string:"https://www.google.by")!)
    var image = Variable<UIImage>(UIImage())
    
    var bag = DisposeBag()
    
    //input from VC
    var openButton = PublishSubject<Void>()
    
    //output to Coordinator
    var openURL = PublishSubject<URL>()
    
    init(item: FeedModel){
        
        title = item.title
        description = item.description
        url = item.url
        image = item.image
        
        openButton
            .subscribe( onNext: { [unowned self] in
                self.openURL.onNext(self.url.value)
            }).disposed(by: bag)
    
    }
    
}
