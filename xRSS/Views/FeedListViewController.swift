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
        
        viewModel.objects
        .asObservable()
            .subscribe(onNext: { [weak self] in
                if $0.0 {
                    self?.tableView.reloadData()
                }
                else {
                    self?.tableView.beginUpdates()
                    self?.tableView.insertRows(at: $0.1.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    self?.tableView.deleteRows(at: $0.2.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    self?.tableView.reloadRows(at: $0.3.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    self?.tableView.endUpdates()
                }
            })
            .disposed(by: bag!)
        
//        viewModel.feedItems.asObservable()
//            .observeOn(main)
//            .bind(to: tableView.rx.items(cellIdentifier: "feedItemCell", cellType: FeedCell.self)) {[weak self] (_, feedItem, cell) in
//
//                cell.viewModel = FeedViewModel(model: feedItem)
//
//                cell.viewModel.title.asObservable().bind(to: cell.titleLabel.rx.text).disposed(by: (self?.bag!)!)
//                cell.viewModel.date.asObservable().bind(to: cell.dateLabel.rx.text).disposed(by: (self?.bag!)!)
//                cell.viewModel.image.asObservable().bind(to: cell.feedImage.rx.image).disposed(by: (self?.bag!)!)
//
//                cell.selectionStyle = .none
//
//            }
//            .disposed(by: bag!)
        
        tableView.rx.modelSelected(FeedModel.self)
            .bind(to: viewModel.feedSelected)
            .disposed(by: bag!)
        
        viewModel.requestData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        bag = nil
        
    }
    

}

extension FeedListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.objectCount.value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedItemCell", for: indexPath) as! FeedCell
        
        cell.viewModel = viewModel.objectViewModel(for: indexPath.row)
        
        return cell
    }
    
}
