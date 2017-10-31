//
//  NewsProviderModel.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/26/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift   

class NewsProvider: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var url = ""
    
    convenience init( _title: String, _url: String){
        self.init()
        title = _title
        url = _url
        
    }
}

let newsProviders = Variable<[NewsProvider]>([
    NewsProvider( _title: "CITYDOG.BY", _url: "https://citydog.by/rss/"),
    NewsProvider( _title: "SVABODA.ORG", _url: "https://www.svaboda.org/api/zvgrppeo_qpm"),
    NewsProvider( _title: "ONLINER.BY", _url: "https://people.onliner.by/feed"),
    NewsProvider( _title: "DEV.BY", _url: "https://dev.by/rss")])
