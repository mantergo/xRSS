//
//  RSSService.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import FeedKit
import RxSwift

public enum CustomError: Error {
    case wrongFormatError
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wrongFormatError:
            return NSLocalizedString("Wrong format", comment: "")
        }
    }
}

class RSSService: NSObject {
    
    static let shared = RSSService()
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

    func getFeed(forURL url: String) -> Observable<[FeedKit.RSSFeedItem]> {
        
        registerBackgroundTask()
        return Observable.create { observer in
            
            let feedURL = URL(string: url)
            let parser = FeedParser(URL: feedURL!)
            
            parser?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                
                switch result {
                    
                case .atom(_):   observer.onError(CustomError.wrongFormatError)
                case let .rss(feed):  observer.onNext(feed.items!)
                    
                case .json(_):    observer.onError(CustomError.wrongFormatError)
                case let .failure(error): observer.onError(error)
                    
                }
                observer.onCompleted()
                self.endBackgroundTask()
            }
            
            return Disposables.create{ print("disposed")}
            
        }
    
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
  
}
