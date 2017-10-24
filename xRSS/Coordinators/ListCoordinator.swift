//
//  ListCoordinator.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit

class ListCoordinator: Coordinator {
    
    weak var appCoordinator: Coordinator!
    weak var navigationController: UINavigationController!
    
    init (navigationController: UINavigationController) {
        
        self.navigationController = navigationController
        
    }
    
    func start() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ListVC") as? ListViewController {
            let viewModel = ListViewModel()
            vc.viewModel = viewModel
            self.navigationController.pushViewController(vc, animated: true)
            
        }
        
        
        
    }
    
    
    
}
