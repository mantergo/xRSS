//
//  MBProgressHUD.swift
//  LoginAppMVVM
//
//  Created by Pavel Lopatine on 10/19/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import RxSwift
import MBProgressHUD
import RxCocoa

extension MBProgressHUD {
    
    var rx_mbprogresshud_animating: AnyObserver<Bool> {
        
        return AnyObserver { event in
            
            MainScheduler.ensureExecutingOnScheduler()
            
            switch (event) {
            case .next(let value):
                if value {
                    let loadingNotification = MBProgressHUD.showAdded(to: (UIApplication.shared.keyWindow?.subviews.last)!, animated: true)
                    loadingNotification.mode = self.mode
                    loadingNotification.label.text = self.label.text
                } else {
                    MBProgressHUD.hide(for: (UIApplication.shared.keyWindow?.subviews.last)!, animated: true)
                }
            case .error(let error):
                let error = "Binding error to UI: \(error)"
                print(error)
            case .completed:
                break
            }
        }
    }
}
