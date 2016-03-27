//
//  EntryPointController.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/25.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import UIKit
import SnapKit

final class EntryPointController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        
        let superview = view
        let vc = NicoAppTabController()
        addChildViewController(vc)
        view.addSubview(vc.view)
        vc.view.snp_makeConstraints { make in
            make.top.equalTo(snp_topLayoutGuideBottom).offset(0)
            make.left.equalTo(superview).offset(0)
            make.right.equalTo(superview).offset(0)
            make.bottom.equalTo(superview).offset(0)
        }
        vc.didMoveToParentViewController(self)
    }
}
