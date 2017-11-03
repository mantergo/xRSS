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
    
    var title: Variable<String> { get set }
    var feedDescription: Variable<String> { get set }
    var url: Variable<URL> { get set }
    var imageURL: Variable<URL> { get set }
    
    var newsFeedTitle: Variable<String> { get set }
    
    //    var openButton: PublishSubject<Void> { get set }
    var openURL: PublishSubject<URL> { get set }
    
    func openUrl()
}
