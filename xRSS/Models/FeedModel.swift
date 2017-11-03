//
//  FeedModel.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/25/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import RxCocoa
import RxSwift
import Alamofire
import HTMLString
import RealmSwift

class FeedModel: Object {
    
    @objc dynamic var newsProviderTitle = ""
    @objc dynamic var title = ""
    @objc dynamic var feedDescription = ""
    @objc dynamic var url = ""
    @objc dynamic var date = Date()
    @objc dynamic var imageURL = ""
    @objc dynamic var isFavourite = false
    
    override static func primaryKey() -> String? {
        return "url"
    }
    
    convenience init (_title: String, _description: String, _url: String, _date:Date, _image: String, _provider: String, _isFavourite: Bool) {
        self.init()
        title = _title.removingHTMLEntities
        feedDescription = _description.removingHTMLEntities.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        url = _url
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "hh:mm     dd.MM.yyyy"
        //let dateString = dateFormatter.string(from: _date as Date)
        date = _date
        imageURL = _image
        newsProviderTitle = _provider
        isFavourite = _isFavourite
        
    }
    
}
