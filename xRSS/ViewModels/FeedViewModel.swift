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
    var image: Variable<UIImage> { get set }
    
    
}

class FeedViewModel: FeedVM {
    
    var title = Variable<String>("")
    var description = Variable<String>("")
    var url = Variable<URL>(URL(string: "https://www.google.by")!)
    var date = Variable<String>("")
    var image = Variable<UIImage>(UIImage())
    
    var bag = DisposeBag()
    
    init (model: FeedModel) {
        
        //   model.url.
        //        model.title.asObservable().bind(to: title).disposed(by: bag)
        //        model.description.asObservable().bind(to: description).disposed(by: bag)
        //        model.date.asObservable().bind(to: date).disposed(by: bag)
        //        model.image.asObservable().bind(to: image).disposed(by: bag)
        //        model.url.asObservable().bind(to: url).disposed(by: bag)
        title.value = model.title
        description.value = model.feedDescription
        url.value = model.url
        date.value = model.date
        Alamofire.request(model.imageURL!).responseImage { response in
            
            if let imageT = response.result.value {
                self.image.value = imageT
            }
        }
    }
}
