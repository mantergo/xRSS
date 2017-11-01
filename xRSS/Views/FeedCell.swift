//
//  FeedCell.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/24/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

class FeedCell: UITableViewCell {
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    
    var viewModel: FeedVM? = nil {
        didSet {
            setupObservables()
        }
    }
    
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        
        viewModel = nil
        titleLabel.text = ""
        dateLabel.text = ""
        feedImage.image = nil
    }
    
    func setupObservables() {
        //viewModel?.image.asObservable().bind(to: feedImage.rx.image).disposed(by: bag)
        viewModel?.title.asObservable().bind(to: titleLabel.rx.text).disposed(by: bag)
        viewModel?.date.asObservable().bind(to: dateLabel.rx.text).disposed(by: bag)
        DataRequest.addAcceptableImageContentTypes(["image/jpg"])
        viewModel?.imageURL.asObservable()
            .subscribeOn(main)
            .subscribe(onNext: { url in
                
                self.feedImage.af_setImage(withURL: url) {
                    response in print(response)
                    self.setNeedsLayout()
                }
            }).disposed(by: bag)
    }
    
}
