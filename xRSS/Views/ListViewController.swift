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
    
    var viewModel: ListViewModel!
    
    private var bag:DisposeBag? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Choose news provider"
        tableView.rowHeight = 60
        tableView.sectionFooterHeight = CGFloat(Float.leastNormalMagnitude)

    }
    
    override func viewWillAppear(_ animated: Bool) {

         bag = DisposeBag()
        
        let progress = MBProgressHUD()
        progress.mode = MBProgressHUDMode.indeterminate
        
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
        
        
        viewModel.indicator.asObservable()
            .bind(to: progress.rx_mbprogresshud_animating)
            .disposed(by: bag!)
        
        setupNavigationFavButton()
       
        
    }
    
    
    func setupNavigationFavButton() {
        
        let favButton = UIButton(frame: CGRect(x:0,y:0,width:26,height:26))
        favButton.widthAnchor.constraint(equalToConstant: 26.0).isActive = true
        favButton.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
        favButton.setImage(R.image.favFilled(), for: .normal)
        let favNavButton = UIBarButtonItem(customView: favButton)
        
        self.navigationItem.setRightBarButton(favNavButton, animated: false)
        
        favButton.rx.tap.asObservable().bind(onNext: viewModel.showFavorite).disposed(by: bag!)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        bag = nil
        
    }

}

