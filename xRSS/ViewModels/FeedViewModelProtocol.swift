//
//  ListViewModelProtocol.swift
//  xRSS
//
//  Created by Pavel Lopatine on 11/2/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import RxSwift


protocol FeedViewModelProtocol {
    
    var title: Variable<String> { get }
    var description: Variable<String> { get }
    var url: Variable<URL> { get }
    var date: Variable<String> { get }
    var imageURL: Variable<URL> { get }
    var isFavorite: Variable<Bool> { get }
    var favouriteButtonImage: Variable<UIImage> { get }
    var favouriteAction: PublishSubject<Void> { get }
    func shareToTwitter()
    func changeFavoriteState()
    func shareToFacebook()
}
