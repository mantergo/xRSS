//
//  AppCoordinator.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    
    func start()
    
}

class AppCoordinator: Coordinator {
    
    var window: UIWindow
    var coordinators = [String : Coordinator]()
    
    init(window: UIWindow)
    {
        self.window = window
        self.window.makeKeyAndVisible()
        
    }
    
    func start() {
        
        let navigationController = UINavigationController()
        self.window.rootViewController = navigationController
        startList(with: navigationController)
        
    }
    
    func startList(with navigationController:UINavigationController){
        
        var listCoordinator:ListCoordinator!
        
        if coordinators.index(forKey: "list") == nil {
            listCoordinator = ListCoordinator(navigationController: navigationController)
            listCoordinator.appCoordinator = self
        } else {
            listCoordinator = coordinators["list"] as! ListCoordinator
        }
        
        coordinators.updateValue(listCoordinator, forKey: "list")
        listCoordinator.start()
        
        
        
    }
    
}
