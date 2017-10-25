//
//  FeedViewController.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import FeedKit


class FeedListViewController: UIViewController {
    
    var viewModel: FeedListViewModel!
    @IBOutlet weak var tableView: UITableView!
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        viewModel.feedItems.asObservable()
//        .observeOn(main)
//            .bind(to: tableView.rx.items(cellIdentifier: "feedItemCell", cellType: UITableViewCell.self)) {(_, feedItem, cell) in
//                cell.textLabel?.text = feedItem.title
//            }
//            .disposed(by: bag)

       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel.feedItems.asObservable()
            .observeOn(main)
            .bind(to: tableView.rx.items(cellIdentifier: "feedItemCell", cellType: UITableViewCell.self)) {(_, feedItem, cell) in
                cell.textLabel?.text = feedItem.title
            }
            .disposed(by: bag)
    }

}
