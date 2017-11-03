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
    
    var title: Variable<String> { get set }
    var description: Variable<String> { get set }
    var url: Variable<URL> { get set }
    var date: Variable<String> { get set }
    var imageURL: Variable<URL> { get set }
    var isSelected: Variable<Bool> { get set }
    var favouriteButtonImage: Variable<UIImage> { get set }
    var favouriteAction: PublishSubject<Void> { get set }
    func changeFavoriteState()
}
