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

protocol FeedListVM {
    
    var feedItems: Variable<[FeedViewModel]> {get set}
    var feedSelected: PublishSubject<FeedViewModel> {get set}
    
}

class FeedListViewModel: FeedListVM{
    
    var feedItems = Variable<[FeedViewModel]>([])
    var feedSelected = PublishSubject<FeedViewModel>()
    
    init(items: [FeedViewModel]) {
        
        self.feedItems.value = items

    }
    
    
    
}
