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
    private var bag:DisposeBag? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News"
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        bag = DisposeBag()
        
        viewModel.feedItems.asObservable()
            .observeOn(main)
            .bind(to: tableView.rx.items(cellIdentifier: "feedItemCell", cellType: FeedCell.self)) {[weak self] (_, feedItem, cell) in
                
                cell.viewModel = FeedViewModel(model: feedItem)
                
                cell.viewModel.title.asObservable().bind(to: cell.titleLabel.rx.text).disposed(by: (self?.bag!)!)
                cell.viewModel.date.asObservable().bind(to: cell.dateLabel.rx.text).disposed(by: (self?.bag!)!)
                cell.viewModel.image.asObservable().bind(to: cell.feedImage.rx.image).disposed(by: (self?.bag!)!)
                
                cell.selectionStyle = .none
                
            }
            .disposed(by: bag!)
        
        tableView.rx.modelSelected(FeedModel.self)
            .bind(to: viewModel.feedSelected)
            .disposed(by: bag!)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        bag = nil
        
    }
    

}
