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
    func objectModel(for index: Int) -> FeedModel
    
    var feedSelected: PublishSubject<FeedModel> { get set }
    var isAnimating: Variable<Bool> { get set }
    var errorResult: PublishSubject<(String, Bool)> { get set }
    func requestData()
    
}

class FeedListViewModel: FeedListVM{
    
    
    let objectCount = Variable<Int>(0)
    let objects = Variable<(Bool, [Int], [Int], [Int])>((true, [], [], []))
    
    var realm: Realm
    let realmObjects: Results<FeedModel>
    var realmObjectsNotification: NotificationToken? = nil
    var errorResult = PublishSubject<(String, Bool)>()
    var provider = NewsProvider()
    
    var bag = DisposeBag()
    
    //navigation bar animation
    var isAnimating = Variable<Bool>(true)
    
    var feedItems = Variable<[FeedModel]>([])
    var feedSelected = PublishSubject<FeedModel>()
    
    
    init(realm: Realm, provider: NewsProvider) {
        self.realm = realm
        
        //delete 7 days old items
        try! realm.write {
            
            realm.delete(realm.objects(FeedModel.self).filter("date<=%@", Date().addingTimeInterval(-60*24*7)))
            
        }
         //get objects for selected newsfeed filtered by date
        realmObjects = realm.objects(FeedModel.self).filter("newsProviderTitle = %@", provider.title).sorted(byKeyPath: "date", ascending: false)
   
        
        
        self.provider = provider
        setupNotifications()
        
        
    }
    
    func setupNotifications() {
        
        //update tableView when new feed fetched
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
    
    //feedviewModel for index
    func objectViewModel(for index: Int) -> FeedVM {
        let object = realmObjects[index]
        let vm = FeedViewModel(model: object)
        return vm
    }
    
    //feedmodel for index
    func objectModel(for index: Int) -> FeedModel {
        return realmObjects[index]
    }
    
    
    func requestData() {
        
        RSSService.shared.getFeed(forURL:self.provider.url)
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
            .subscribeOn(async)
            //parse feeditem to feedmodel
            .flatMap{ (items) -> Observable<[FeedModel]> in
                var feedArray = [FeedModel]()
                for item in items {
                    var imageUrl = ""
                    if let media = item.media?.mediaThumbnails {
                        imageUrl = (media[0].attributes?.url)!
                    }
                    else {
                        if let media = item.media?.mediaContents {
                            imageUrl = (media[0].attributes?.url)!
                        } else {
                            
                            imageUrl = (item.enclosure?.attributes?.url)!
                            
                        }
                    }
                    
                    feedArray.append(FeedModel(_title: item.title!, _description: item.description!, _url: item.link!, _date: item.pubDate!, _image:
                        imageUrl, _provider: self.provider.title))
                    
                }
                return Observable.just(feedArray)
            }
            //add new feed to DB
            .subscribe( onNext: { [weak self] items in
                do{ for item in items {
                    let realm = try! Realm()
                    if let _ = realm.object(ofType: FeedModel.self, forPrimaryKey: item.url){
                        
                    } else {
                        
                        try realm.write {
                            realm.add(item)
                        }
                    }
                    }
                } catch let error as NSError {
                    self?.errorResult.onNext((error.localizedDescription, false))
                }
                },
                        onCompleted: {
                            self.isAnimating.value = false
            })
            .disposed(by: bag)
    }
    
}

