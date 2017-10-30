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
    
    var feedItems: Variable<[FeedModel]> { get set }
    var feedSelected: PublishSubject<FeedModel> { get set }
    
}

class FeedListViewModel: FeedListVM{
    
    var feedItems = Variable<[FeedModel]>([])
    var feedSelected = PublishSubject<FeedModel>()
    
    init(items: [FeedModel]) {
        
        self.feedItems.value = items

    }
}
