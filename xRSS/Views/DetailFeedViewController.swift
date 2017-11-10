//
//  DetailFeedViewController.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/30/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DetailFeedViewController: UIViewController {
    
    var viewModel: DetailFeedViewModelProtocol!
    private var bag:DisposeBag? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var openFullButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        bag = DisposeBag()
        
        viewModel.title.asObservable().bind(to: titleLabel.rx.text).disposed(by: bag!)
        
        viewModel.feedDescription.asObservable().bind(to: descriptionTextView.rx.text).disposed(by: bag!)
  
        viewModel.newsFeedTitle.asObservable().bind(to: navigationItem.rx.title).disposed(by: bag!)
        
        viewModel.imageURL.asObservable()
            .subscribe(onNext: {[weak self] url in
                self?.image.af_setImage(withURL: url)
            }).disposed(by: bag!)
        
        openFullButton.rx.tap
            .asObservable()
            .bind(onNext: viewModel.openUrl)
            .disposed(by: bag!)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        bag = nil
    }
    
}
