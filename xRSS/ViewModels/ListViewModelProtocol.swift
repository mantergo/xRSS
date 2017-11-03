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
    
    var bag: DisposeBag { get }
    var indicator: ActivityIndicator { get }
    var newsProviderSelected: PublishSubject<NewsProvider> { get set }
    var feedReady: PublishSubject<[FeedModel]> { get set }
    var errorResult: PublishSubject<(String, Bool)> { get set }
  //  func showFavorite(sender: AnyObject)
}
