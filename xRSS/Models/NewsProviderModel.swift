//
//  NewsProviderModel.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/26/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import RxSwift

struct NewsProvider {
    
    var title = ""
    var url = ""
    
    init( _title: String, _url: String){
        
        title = _title
        url = _url
        
    }
}

let newsProviders = Variable<[NewsProvider]>([
    NewsProvider( _title: "CITYDOG.BY", _url: "https://citydog.by/rss/"),
    NewsProvider( _title: "SVABODA.ORG", _url: "https://www.svaboda.org/api/zvgrppeo_qpm"),
    NewsProvider( _title: "ONLINER.BY", _url: "https://people.onliner.by/feed"),
    NewsProvider( _title: "DEV.BY", _url: "https://dev.by/rss")])
