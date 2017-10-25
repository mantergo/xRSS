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
    
    init (_title: String, _description: String, _url: String) {
        
        title = _title
        description = _description
        url = URL(string: _url)!
        
    }
}
