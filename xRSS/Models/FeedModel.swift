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
    
    @objc dynamic var newsProvider: NewsProvider?
    @objc dynamic var title = ""
    @objc dynamic var feedDescription = ""
    @objc dynamic var url = URL(string:"https://www.google.by")!
    @objc dynamic var date = ""
    @objc dynamic var imageURL: URL?
    
    override static func primaryKey() -> String? {
        return "url"
    }
    
    convenience init (_title: String, _description: String, _url: String, _date:Date, _image: URL) {
        self.init()
        title = _title.removingHTMLEntities
        feedDescription = _description.removingHTMLEntities.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        url = URL(string: _url)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm     dd.MM.yyyy"
        let dateString = dateFormatter.string(from: _date as Date)
        date = dateString
        imageURL = _image
    
    }
    
}
