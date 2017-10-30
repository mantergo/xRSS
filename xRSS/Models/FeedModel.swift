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

class FeedModel {
    
    var title = Variable<String>("")
    var description = Variable<String>("")
    var url = Variable<URL>(URL(string:"https://www.google.by")!)
    var date = Variable<String>("")
    var image = Variable<UIImage>(UIImage())
    
    init() {
        
    }
    
    init (_title: String, _description: String, _url: String, _date:Date, _image: URL) {
        
        title.value = _title.removingHTMLEntities
        description.value = _description.removingHTMLEntities.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        url.value = URL(string: _url)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm     dd.MM.yyyy"
        let dateString = dateFormatter.string(from: _date as Date)
        date.value = dateString
        
        Alamofire.request(_image).responseImage { response in
            
            if let imageT = response.result.value {
                self.image.value = imageT
            }
        }
    }
    
}
