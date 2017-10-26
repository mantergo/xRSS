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
    
    var viewModel: FeedListVM!
    @IBOutlet weak var tableView: UITableView!
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel.feedItems.asObservable()
            .observeOn(main)
            .bind(to: tableView.rx.items(cellIdentifier: "feedItemCell", cellType: FeedCell.self)) {(_, feedItem, cell) in
                
                cell.titleLabel.text = feedItem.title
                cell.descriptionLabel.text = feedItem.description
                cell.selectionStyle = .none
                
            }
            .disposed(by: bag)
        
        tableView.rx.modelSelected(FeedViewModel.self)
            .bind(to: viewModel.feedSelected)
            .disposed(by: bag)
        
    }

}
