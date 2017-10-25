//
//  FeedViewModel.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import FeedKit
import RxSwift
import RxCocoa

class FeedListViewModel{
    
    var feedItems = Variable<[FeedViewModel]>([])
    let feedSelected = PublishSubject<FeedViewModel>()
    
    init(items: [FeedViewModel]) {
        
        self.feedItems.value = items

    }
    
    
    
}
