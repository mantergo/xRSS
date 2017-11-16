//
//  FeedViewModel.swift
//  xRSS
//
//  Created by Pavel Lopatine on 10/30/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import TwitterKit
import FacebookShare
import Branch

class FeedViewModel: FeedViewModelProtocol {
    
    var title = Variable<String>("")
    var description = Variable<String>("")
    var url = Variable<URL>(URL(string: "https://www.google.by")!)
    var date = Variable<String>("")
    var imageURL = Variable<URL>(URL(string: "https://www.google.by")!)
    var isFavorite = Variable<Bool>(false)
    var favouriteButtonImage = Variable<UIImage>(R.image.favEmpty2()!)
    var favouriteAction = PublishSubject<Void>()
    
    private var bag:DisposeBag? = nil
    
    convenience init (model: FeedModel) {
        
        self.init()
        
        bag = DisposeBag()
        title.value = model.title
        description.value = model.feedDescription
        url.value = URL(string: model.url)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm     dd.MM.yyyy"
        let dateString = dateFormatter.string(from: model.date)
        date.value = dateString
        imageURL.value = URL(string: model.imageURL)!
        isFavorite.value = model.isFavourite
        isFavorite.asObservable()
            .subscribe(onNext:{ value in
                self.favouriteButtonImage.value = (value ? R.image.favFilled() : R.image.favEmpty2())!
            }).disposed(by: bag!)
        
    }
    

    
    func shareToTwitter(){

        if (Twitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            // App must have at least one logged-in user to compose a Tweet
            Alamofire.request(imageURL.value.absoluteString).responseImage {[weak self] response in
                debugPrint(response)
                
                if let image = response.result.value {
                    let composer = TWTRComposer()
                    composer.setText((self?.title.value)! + "\n" + (self?.url.value.absoluteString)!)
                    composer.setImage(image)
                    composer.show(from: (UIApplication.shared.keyWindow?.rootViewController)!, completion: nil)
                }
            }
        } else {
            // Log in, and then check again
            Twitter.sharedInstance().logIn {[weak self] session, error in
                if session != nil { // Log in succeeded
                    Alamofire.request((self?.imageURL.value.absoluteString)!).responseImage { response in
                        debugPrint(response)
                        
                        if let image = response.result.value {
                            let composer = TWTRComposer()
                            composer.setText((self?.title.value)! + "\n" + (self?.url.value.absoluteString)!)
                            composer.setImage(image)
                            composer.show(from: (UIApplication.shared.keyWindow?.rootViewController)!, completion: nil)
                        }
                    }
                } else {
                    self?.errorAlert(for: "Twitter")
                }
            }
        }
    }
    
    func shareToFacebook() {
        
        let content: LinkShareContent = LinkShareContent(url: url.value)
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            print(result)
        }
        let post = String(format: "fbauth2://")
        let canOpenURL = UIApplication.shared.canOpenURL(URL(string:post)!)
        if (canOpenURL) {
             try! shareDialog.show()
        }
        else {
            self.errorAlert(for: "Facebook")
        }
    }
    
    func rssShare() {
        
        let buo = BranchUniversalObject(canonicalIdentifier: "id")
        buo.title = title.value
        buo.contentDescription = description.value
        buo.imageUrl = imageURL.value.absoluteString
        buo.contentIndexMode = .public
        buo.canonicalUrl = url.value.absoluteString
        
        let lp: BranchLinkProperties = BranchLinkProperties()
        lp.addControlParam("$ios_url", withValue: "xRSS://")
        
        
        
        buo.getShortUrl(with: lp) {(url, error) in
            print(url ?? "")
            buo.showShareSheet(with: lp, andShareText: "", from: UIApplication.shared.keyWindow?.rootViewController) { (activityType, completed) in
                print(activityType ?? "")
            }
        }
    }
    
    func errorAlert(for appName: String) {
        
        let alert = UIAlertController(title: "No \(appName) Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        alert.addAction(ok)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: false, completion: nil)
    }
    
    func changeFavoriteState(){
        
        DBService.shared.setState(selected: !self.isFavorite.value, for: self.url.value)
        self.isFavorite.value = !self.isFavorite.value
        
    }
}
