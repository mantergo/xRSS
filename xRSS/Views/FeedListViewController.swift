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
    
    private let refreshControl = UIRefreshControl()
    var viewModel: FeedListViewModelProtocol!
    let loadingBar: LoadingView = LoadingView()
    @IBOutlet weak var newsProviderBackgroundImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    private var bag:DisposeBag? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "News"
        
        setupTableView()
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        bag = DisposeBag()
        
        newsProviderBackgroundImage.image = UIImage(named: viewModel.provider.title)
        
        viewModel.isAnimating.asObservable()
            .subscribeOn(main)
            .observeOn(main)
            .subscribe(onNext: {[weak self] event in
                
                if event {
                    self?.loadingBar.startAnimating()
                }
                else {
                    self?.loadingBar.stopAnimation()
                    self?.refreshControl.endRefreshing()
                }
                
            }).disposed(by: bag!)
        
        //update tableView if there are some changes in DB
        viewModel.objects
            .observeOn(main)
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
    
    func setupTableView() {
        
        tableView.rowHeight = 200
        tableView.dataSource = self
        tableView.delegate = self
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        bag = nil
        self.loadingBar.stopAnimation()
        
    }
    
    @objc func refreshData(_ sender: Any) {
        
        loadingBar.startAnimating()
        viewModel.requestData()
    }
}

extension FeedListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return viewModel.objectCount.value
        } else {
            return 0
        }
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
