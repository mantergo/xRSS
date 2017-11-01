//
//  FeedViewModel.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/30/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire

protocol FeedVM {
    
    var title: Variable<String> { get set }
    var description: Variable<String> { get set }
    var url: Variable<URL> { get set }
    var date: Variable<String> { get set }
    var imageURL: Variable<URL> { get set }
    
}

class FeedViewModel: FeedVM {
    
    var title = Variable<String>("")
    var description = Variable<String>("")
    var url = Variable<URL>(URL(string: "https://www.google.by")!)
    var date = Variable<String>("")
    var imageURL = Variable<URL>(URL(string: "https://www.google.by")!)
    
    var bag = DisposeBag()
    
    init (model: FeedModel) {
        
 
        title.value = model.title
        description.value = model.feedDescription
        url.value = URL(string: model.url)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm     dd.MM.yyyy"
        let dateString = dateFormatter.string(from: model.date)
        date.value = dateString
        imageURL.value = URL(string: model.imageURL)!
        
    }
}
