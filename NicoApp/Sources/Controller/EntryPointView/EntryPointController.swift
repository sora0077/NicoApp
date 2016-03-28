//
//  EntryPointController.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/25.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import UIKit
import SnapKit
import Font_Awesome_Swift

final class EntryPointController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        
        let superview = view
        let vc = UINavigationController(rootViewController: NicoAppTabController())
        vc.navigationBar.barTintColor = UIColor(red:0.14, green:0.14, blue:0.14, alpha:1.00)
        vc.navigationBar.translucent = false
        vc.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        vc.navigationBar.shadowImage = UIImage()
        addChildViewController(vc)
        view.addSubview(vc.view)
        vc.view.snp_makeConstraints { make in
            make.top.equalTo(superview)
            make.left.equalTo(superview)
            make.right.equalTo(superview)
            make.bottom.equalTo(superview)
        }
        vc.didMoveToParentViewController(self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
