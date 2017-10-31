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
                // An error occurred while opening the Realm file on the background worker thread
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
            
            RSSService.shared
                .getFeed(forURL: URL(""))
                .subscribeOn(ConcurrentMainScheduler.instance)
                .observeOn(main)
                .do(onNext: {(objects)
                    try! realm.write(objects, update: true)
                    })
                    .observeOn(MainScheduler.instance)
                    .subscribe()
                    .disposed(by: bag)
            
        }
}
