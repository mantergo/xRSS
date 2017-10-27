//
//  RxAlamofire+UIImage.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/27/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

extension UIImageView {
    
    public func imageFromUrl(urlString: String) {
        requestData(.get, urlString)
            .observeOn(main)
            .subscribe (onNext: { ( _, data) in
                self.image = UIImage(data: data)
                
                }
        ).dispose()
    }
    
    
}
