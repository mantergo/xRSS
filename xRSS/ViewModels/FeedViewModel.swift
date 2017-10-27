//
//  FeedViewModel.swift
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

class FeedViewModel {
    
    var title = ""
    var description = ""
    var url:URL!
    var date:String = ""
    var image: UIImage!
    
    init (_title: String, _description: String, _url: String, _date:Date, _image: URL) {
        
        title = _title
        description = _description
        url = URL(string: _url)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm     dd.MM.yyyy"
        let dateString = dateFormatter.string(from: _date as Date)
        date = dateString
        //image = _image
        Alamofire.request(_image).responseImage { response in
        
            if let imageT = response.result.value {
                self.image = imageT
            }
    }
    }
    
}
