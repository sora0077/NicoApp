//
//  EntryPointController.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/25.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import UIKit

final class EntryPointController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = NicoAppTabController()
        addChildViewController(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
}
