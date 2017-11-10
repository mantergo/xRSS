//
//  ListViewModelProtocol.swift
//  xRSS
//
//  Created by Pavel Lopatine on 11/2/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import RxSwift

protocol ListViewModelProtocol {
    
    var indicator: RxActivityIndicator { get }
    var newsProviderSelected: PublishSubject<NewsProvider> { get }
    var feedReady: PublishSubject<[FeedModel]> { get }
    var errorResult: PublishSubject<(String, Bool)> { get }

}
