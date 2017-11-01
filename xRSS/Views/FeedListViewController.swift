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
    let loadingBar: LoadingView = LoadingView()
    
    @IBOutlet weak var tableView: UITableView!
    private var bag:DisposeBag? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News"
        tableView.rowHeight = 200
      //  tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        bag = DisposeBag()
        
        viewModel.isAnimating.asObservable()
            .subscribeOn(main)
            .observeOn(main)
            .subscribe(onNext: {[weak self] event in
                
                if event {
                    self?.loadingBar.startAnimating()
                }
                else {
                    self?.loadingBar.stopAnimation()
                   // self?.loadingBar.height = 0
                }
                
            }).disposed(by: bag!)
        
        viewModel.objects
        .asObservable()
            .subscribe(onNext: { [weak self] in
                if $0.0 {
                    self?.tableView.reloadData()
                }
                else {
                    self?.tableView.beginUpdates()
                    self?.tableView.deleteRows(at: $0.1.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    self?.tableView.insertRows(at: $0.2.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    self?.tableView.reloadRows(at: $0.3.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    self?.tableView.endUpdates()
                }
            })
            .disposed(by: bag!)
        
        viewModel.requestData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        bag = nil
        self.loadingBar.stopAnimation()
        
    }
    

}

extension FeedListViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.feedSelected.onNext(viewModel.objectModel(for: indexPath.row))
        
    }
    
    
    
}
