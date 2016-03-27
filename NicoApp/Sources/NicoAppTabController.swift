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

class NicoAppTabController: ButtonBarPagerTabStripViewController {
    
    let graySpotifyColor = UIColor(red:0.14, green:0.14, blue:0.14, alpha:1.00)
    let darkGraySpotifyColor = UIColor(red: 19/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
    
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
}
