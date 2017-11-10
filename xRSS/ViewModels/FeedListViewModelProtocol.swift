//
//  ListViewModelProtocol.swift
//  xRSS
//
//  Created by Pavel Lopatine on 11/2/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import RxSwift

protocol FeedListViewModelProtocol {
    
    var objectCount: Variable<Int> { get }
    var objects: PublishSubject<(Bool, [Int], [Int], [Int])> { get }
    
    func objectViewModel(for index: Int) -> FeedViewModelProtocol
    func objectModel(for index: Int) -> FeedModel
    
    var provider: NewsProvider { get }
    
    var feedSelected: PublishSubject<FeedModel> { get }
    var isAnimating: Variable<Bool> { get }
    var errorResult: PublishSubject<(String, Bool)> { get }
    func requestData()
    
}
