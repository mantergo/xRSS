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
    // var objects: Variable<(Bool, [Int], [Int], [Int])> { get }
    var objects: PublishSubject<(Bool, [Int], [Int], [Int])> { get }
    
    func objectViewModel(for index: Int) -> FeedViewModelProtocol
    func objectModel(for index: Int) -> FeedModel
    
    var provider: NewsProvider { get set }
    
    var feedSelected: PublishSubject<FeedModel> { get set }
    var isAnimating: Variable<Bool> { get set }
    var errorResult: PublishSubject<(String, Bool)> { get set }
    func requestData()
    
}
