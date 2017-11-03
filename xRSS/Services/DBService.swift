//
//  DBService.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import RealmSwift

class DBService {
    
    let realm:Realm
    static let shared = DBService()
    
    
    init() {
        
        realm = try! Realm()
        
    }
    
    func cleanOutdatedFeed () {
        
        //delete 7 days old items
        try! realm.write {
            
            realm.delete(realm.objects(FeedModel.self).filter("date<=%@", Date().addingTimeInterval(-60*60*24*7)))
            
        }
        
    }
    
    func setState(selected isSelected: Bool, for url: URL){
        
        let object = realm.object(ofType: FeedModel.self, forPrimaryKey: url.absoluteString)
        
        try! realm.write {
            object?.isFavourite = isSelected
        }
        
        
        
    }
    
}
