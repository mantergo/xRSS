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


class FeedViewModel: FeedViewModelProtocol {
    
    var title = Variable<String>("")
    var description = Variable<String>("")
    var url = Variable<URL>(URL(string: "https://www.google.by")!)
    var date = Variable<String>("")
    var imageURL = Variable<URL>(URL(string: "https://www.google.by")!)
    var isSelected = Variable<Bool>(false)
    var favouriteButtonImage = Variable<UIImage>(R.image.favEmpty2()!)
    var favouriteAction = PublishSubject<Void>()
    
    private var bag:DisposeBag? = nil
    
    convenience init (model: FeedModel) {
        
        self.init()
        
        bag = DisposeBag()
        title.value = model.title
        description.value = model.feedDescription
        url.value = URL(string: model.url)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm     dd.MM.yyyy"
        let dateString = dateFormatter.string(from: model.date)
        date.value = dateString
        imageURL.value = URL(string: model.imageURL)!
        isSelected.value = model.isFavourite
        isSelected.asObservable()
            .subscribe(onNext:{ value in
                self.favouriteButtonImage.value = (value ? R.image.favFilled() : R.image.favEmpty2())!
            }).disposed(by: bag!)
        
        
    }
    
    func changeFavoriteState(){
        
        DBService.shared.setState(selected: !self.isSelected.value, for: self.url.value)
        self.isSelected.value = !self.isSelected.value
        
    }
    
    
}
