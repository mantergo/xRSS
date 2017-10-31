//
//  FeedViewModel.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import FeedKit
import RxSwift
import RxCocoa
import RealmSwift

protocol FeedListVM {
    
    var objectCount: Variable<Int> { get }
    var objects: Variable<(Bool, [Int], [Int], [Int])> { get }
    
    func objectViewModel(for index: Int) -> FeedVM
    
    //    var feedItems: Variable<[FeedModel]> { get set }
    var feedSelected: PublishSubject<FeedModel> { get set }
    
    func requestData()
    
}

class FeedListViewModel: FeedListVM{
    
    
    let objectCount = Variable<Int>(0)
    let objects = Variable<(Bool, [Int], [Int], [Int])>((true, [], [], []))
    
    let realm: Realm
    let realmObjects: Results<FeedModel>
    var realmObjectsNotification: NotificationToken? = nil
    
    var bag = DisposeBag()
    
    
    var feedItems = Variable<[FeedModel]>([])
    var feedSelected = PublishSubject<FeedModel>()
    
    init(realm: Realm) {
        self.realm = realm
        realmObjects = realm.objects(FeedModel.self)
//            .sorted(by: { (feed1, feed2) -> Bool in
//            return true
//        })
     //   self.feedItems.value = items
        setupNotifications()
        
    }
    
    func setupNotifications() {
        realmObjectsNotification = realmObjects.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let results):
                self?.objectCount.value = results.count
                self?.objects.value = (true, [], [], [])
            case .update(let results, let deletions, let insertions, let modifications):
                self?.objectCount.value = results.count
                self?.objects.value = (false, deletions, insertions, modifications)
            case .error(let error):
            
                fatalError("\(error)")
            }
        }
    }
        
        func objectViewModel(for index: Int) -> FeedVM {
            let object = realmObjects[index]
            let vm = FeedViewModel(model: object)
            return vm
        }
        
        
        func requestData() {
            ///беда!
//            .flatMap { newsProvider -> Observable<[FeedKit.RSSFeedItem]> in
            
                RSSService.shared.getFeed(forURL: (realmObjects[0].newsProvider?.url)!)
                   // .trackActivity(self.indicator)
                    .catchError({[weak self] (error) -> Observable<[FeedKit.RSSFeedItem]> in
                        print(error)
                        self?.errorResult.onNext((error.localizedDescription, false))
                        return Observable.create{ observer in
                            observer.on(.next([]))
                            return Disposables.create {
                                print("disposed")
                            }
                        }
                    })
                }
                .observeOn(main)
                .flatMap{ (items) -> Observable<[FeedModel]> in
                    var feedArray = [FeedModel]()
                    for item in items {
                        
                        
                        var imageUrl = URL(string: "")
                        if let media = item.media?.mediaThumbnails {
                            imageUrl = URL(string:(media[0].attributes?.url)!)
                        }
                        else {
                            if let media = item.media?.mediaContents {
                                imageUrl = URL(string:(media[0].attributes?.url)!)
                            } else {
                                
                                imageUrl = URL(string: (item.enclosure?.attributes?.url)!)
                                
                            }
                        }
                        
                        feedArray.append(FeedModel(_title: item.title!, _description: item.description!, _url: item.link!, _date: item.pubDate!, _image:
                            imageUrl!))
                        
                    }
                    return Observable.just(feedArray)
                }
                .subscribe(onNext: {[weak self] items in
                    try! realm.write(items)
                    
                })
                .disposed(by: bag)
            
//            RSSService.shared
//                .getFeed(forURL: (realmObjects[0].newsProvider?.url)!)
//                .subscribeOn(ConcurrentMainScheduler.instance)
//                .observeOn(main)
//
//                .do(onNext: {(objects)
//                    try! realm.write(objects, update: true)
//                    })
//                    .observeOn(MainScheduler.instance)
//                    .subscribe()
//                    .disposed(by: bag)
            
        }
}
