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

class FeedListViewModel: FeedListViewModelProtocol{
    
    let objectCount = Variable<Int>(0)
    let objects = PublishSubject<(Bool, [Int], [Int], [Int])>()
    var realm: Realm
    let realmObjects: Results<FeedModel>
    var realmObjectsNotification: NotificationToken? = nil
    var errorResult = PublishSubject<(String, Bool)>()
    var provider = NewsProvider()
    
    private var bag:DisposeBag? = nil
    
    //navigation bar animation
    var isAnimating = Variable<Bool>(true)
    
    var feedItems = Variable<[FeedModel]>([])
    var feedSelected = PublishSubject<FeedModel>()
    
    init(realm: Realm, provider: NewsProvider) {
        
        bag = DisposeBag()
        self.realm = realm
        
        //get objects for selected newsfeed filtered by date
        //empty title means favorite category
        if provider.title.isEmpty {
            
            realmObjects = realm.objects(FeedModel.self).filter("isFavourite=1")
            
        } else {
            
            realmObjects = realm.objects(FeedModel.self).filter("newsProviderTitle = %@", provider.title).sorted(byKeyPath: "date", ascending: false)
        }
        setupNotifications()
        self.provider = provider
        
    }
    
    func setupNotifications() {
        
        //update tableView when new feed fetched
        realmObjectsNotification = realmObjects.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let results):
                self?.objectCount.value = results.count
                self?.objects.onNext((true, [], [], []))
            case .update(let results, let deletions, let insertions, let modifications):
                self?.objectCount.value = results.count
                if(modifications.count == 0){
                    self?.objects.onNext((false, deletions, insertions, modifications))
                }
            case .error(let error):
                
                fatalError("\(error)")
            }
        }
    }
    
    //feedViewModel for index
    func objectViewModel(for index: Int) -> FeedViewModelProtocol {
        let object = realmObjects[index]
        let vm = FeedViewModel(model: object)
        return vm
    }
    
    //feedModel for index
    func objectModel(for index: Int) -> FeedModel {
        return realmObjects[index]
    }
    
    @objc func requestData() {
        
        //if provider.title is Empty, then favorited feed is displayed and there is no neen to requestData()
        if(!provider.title.isEmpty) {
            
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
                        //if-elses because feed image has different path for different feeds
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
                            imageUrl, _provider: self.provider.title, _isFavourite: false))
                        
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
                .disposed(by: bag!)
        } else {
            self.isAnimating.value = false
        }}
    
}

