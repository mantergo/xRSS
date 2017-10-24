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
    
    var viewModel: ListViewModel!
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose news provider"
        tableView.rowHeight = 60
       
        viewModel.newsProviders
        .observeOn(main)
            .bind(to: tableView.rx.items(cellIdentifier: "listItemCell", cellType: UITableViewCell.self)) { (_, newsProvider, cell) in
                cell.textLabel?.text = newsProvider
            }
            .disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

