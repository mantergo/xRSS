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
    @IBOutlet weak var favouriteButton: UIButton!
    
    
    var viewModel: FeedViewModelProtocol = FeedViewModel() {
        didSet {
            setupObservables()
        }
    }
    
    private var bag:DisposeBag? = nil
    
//    override func awakeFromNib() {
//
//    }
    
    override func prepareForReuse() {
        bag = nil
       // viewModel = nil
        titleLabel.text = ""
        dateLabel.text = ""
        feedImage.image = nil
        favouriteButton.setImage(UIImage(named: "favEmpty2"), for: .normal)
        
    }
    
    func setupObservables() {
       bag = DisposeBag()
        
        viewModel.title.asObservable().bind(to: titleLabel.rx.text).disposed(by: bag!)
        viewModel.date.asObservable().bind(to: dateLabel.rx.text).disposed(by: bag!)
      //  viewModel?.isFavourite.asObservable().bind(to:
       //     favouriteButton.rx.isSelected).disposed(by: bag)
        
        viewModel.favouriteButtonImage.asObservable().bind(to:
            favouriteButton.rx.image(for: .normal)).disposed(by: bag!)
       // favouriteButton.rx.tap.asObservable().bind(to: viewModel?.favouriteAction).disposed(by: bag)
        
        favouriteButton.rx.tap
            .asObservable()
            .bind(onNext: viewModel.changeFavoriteState)
            .disposed(by: bag!)
        
        
        //  DataRequest.addAcceptableImageContentTypes(["image/jpg"])
        viewModel.imageURL.asObservable()
            .subscribeOn(main)
            .subscribe(onNext: { url in
                
                self.feedImage.af_setImage(withURL: url) {
                    response in print(response)
                    self.setNeedsLayout()
                }
            }).disposed(by: bag!)
    }
    
}
