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


class ListViewModel: ListViewModelProtocol {
    
    var bag = DisposeBag()
    var indicator = ActivityIndicator()
    
    //input
    var newsProviderSelected = PublishSubject<NewsProvider>()
    
    //output
    var feedReady = PublishSubject<[FeedModel]>()
    var errorResult = PublishSubject<(String, Bool)>()
    
    func showFavorite() {
        
        newsProviderSelected.onNext(NewsProvider())
        
    }
   
    init() {

    }
    
}
