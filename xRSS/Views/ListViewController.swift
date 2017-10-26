//
//  ViewController.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    
    var viewModel: ListVM!
    var bag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose news provider"
        tableView.rowHeight = 60
       
        newsProviders.asObservable()
        .observeOn(main)
            .bind(to: tableView.rx.items(cellIdentifier: "listItemCell", cellType: UITableViewCell.self)) { (_, newsProvider, cell) in
                cell.textLabel?.text = newsProvider.title
                cell.selectionStyle = .none
            }
            .disposed(by: bag)
        
        tableView.rx.modelSelected(NewsProvider.self)
        .bind(to: viewModel.newsProviderSelected)
            .disposed(by: bag)
        
    }




}

