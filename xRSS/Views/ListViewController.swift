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
import MBProgressHUD

class ListViewController: UIViewController {
    
    var viewModel: ListVM!
    private var bag:DisposeBag? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Choose news provider"
        tableView.rowHeight = 60
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

         bag = DisposeBag()
         newsProviders.asObservable()
            .observeOn(main)
            .bind(to: tableView.rx.items(cellIdentifier: "listItemCell", cellType: UITableViewCell.self)) { (_, newsProvider, cell) in
                cell.textLabel?.text = newsProvider.title
                cell.selectionStyle = .none
            }
            .disposed(by: bag!)
        
        tableView.rx.modelSelected(NewsProvider.self)
            .bind(to: viewModel.newsProviderSelected)
            .disposed(by: bag!)
        
        let progress = MBProgressHUD()
        progress.mode = MBProgressHUDMode.indeterminate
        
        viewModel.indicator.asObservable()
            .bind(to: progress.rx_mbprogresshud_animating)
            .disposed(by: bag!)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        bag = nil
        
    }

}

