//
//  ListViewModelProtocol.swift
//  xRSS
//
//  Created by Pavel Lopatine on 11/2/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import RxSwift

protocol DetailFeedViewModelProtocol {
    
    var title: Variable<String> { get }
    var feedDescription: Variable<String> { get }
    var url: Variable<URL> { get }
    var imageURL: Variable<URL> { get }
    var newsFeedTitle: Variable<String> { get }
    var openURL: PublishSubject<URL> { get }
    
    func openUrl()
}
