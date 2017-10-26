//
//  FeedViewModel.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/25/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation

class FeedViewModel {
    
    var title = ""
    var description = ""
    var url:URL!
    var date:String = ""
    
    init (_title: String, _description: String, _url: String, _date:Date) {
        
        title = _title
        description = _description
        url = URL(string: _url)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm     dd.MM.yyyy"
        let dateString = dateFormatter.string(from: _date as Date)
        date = dateString
    }
}
