//
//  NicoAppTabController.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/27.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import UIKit
import SnapKit
import XLPagerTabStrip
import RxSwift

class NicoAppTabController: ButtonBarPagerTabStripViewController {
    
    let graySpotifyColor = UIColor(red:0.14, green:0.14, blue:0.14, alpha:1.00)
    let darkGraySpotifyColor = UIColor(red: 19/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {

        // Do any additional setup after loading the view.
        settings.style.buttonBarBackgroundColor = graySpotifyColor
        settings.style.buttonBarItemBackgroundColor = graySpotifyColor
        settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Light", size:14) ?? UIFont.systemFontOfSize(14)
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .blackColor()
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20
        
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(red: 138/255.0, green: 138/255.0, blue: 144/255.0, alpha: 1.0)
            newCell?.label.textColor = .whiteColor()
        }
        super.viewDidLoad()
        
        let superview = view
        buttonBarView.snp_makeConstraints { make in
            make.top.equalTo(snp_topLayoutGuideBottom)
            make.left.equalTo(superview)
            make.right.equalTo(superview)
            make.height.equalTo(settings.style.buttonBarHeight ?? 44)
        }
        
        automaticallyAdjustsScrollViewInsets = false
        containerView.snp_makeConstraints { make in
            make.top.equalTo(buttonBarView.snp_bottom)
            make.left.equalTo(superview)
            make.right.equalTo(superview)
            make.bottom.equalTo(superview)
        }
        
        let logo = UIBarButtonItem(image: UIImage(named: "logo-icon"), style: .Plain, target: nil, action: nil)
        logo.tintColor = .whiteColor()
        navigationItem.leftBarButtonItem = logo
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBarButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        return domain.repository.ranking.categories().map {
            RankingListViewController(category: $0, period: .Hourly)
        }
    }
    
    func updateBarButtons() {
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacer.width = 16
        
        let search = UIBarButtonItem()
        search.setFAIcon(.FASearch, iconSize: 20)
        search.tintColor = .whiteColor()
        
        if let s = try? domain.repository.session.session(), session = s {
            print(session)
            let account = UIBarButtonItem()
            account.setFAIcon(.FAPowerOff, iconSize: 20)
            account.tintColor = .whiteColor()
            account.target = self
            account.action = #selector(NicoAppTabController.logoutAction)
            
            navigationItem.setRightBarButtonItems([account, spacer, search], animated: true)
        } else {
            let account = UIBarButtonItem()
            account.setFAIcon(.FAUser, iconSize: 20)
            account.tintColor = .whiteColor()
            account.target = self
            account.action = #selector(NicoAppTabController.loginAction)
            
            navigationItem.setRightBarButtonItems([account, spacer, search], animated: true)
        }
    }
}

extension NicoAppTabController {
    
    @objc func loginAction() {
        
        let vc = LoginViewController()
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @objc func logoutAction() {
        
        domain.repository.session.logout().subscribeNext { [weak self] in
            self?.updateBarButtons()
        }.addDisposableTo(disposeBag)
    }
}
