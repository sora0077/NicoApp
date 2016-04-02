//
//  PlayerHostController.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/31.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import UIKit
import NicoEntity

import RxSwift
import SnapKit


class PlayerHostController: UIViewController {

    private weak var playerViewController: PlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func play(video: Video) {
        guard let vc = playerViewController else {
            let vc = PlayerViewController(video: video)
            let superview = view
            view.addSubview(vc.view)
            vc.view.snp_makeConstraints { make in
                make.width.equalTo(200)
                make.height.equalTo(150)
                make.right.equalTo(superview.snp_right)
                make.bottom.equalTo(superview.snp_bottom)
            }
            vc.view.layer.cornerRadius = 2
            vc.view.layer.masksToBounds = true
            view.layer.shadowRadius = 8
            view.layer.shadowOpacity = 0.6
            view.layer.shadowColor = UIColor(red:0.14, green:0.14, blue:0.14, alpha:1.00).CGColor
//            vc.view.transform = CGAffineTransformMakeScale(0.6, 0.6)
            
            addChildViewController(vc)
            vc.didMoveToParentViewController(self)
            playerViewController = vc
            return
        }
        
        vc.append(video)
    }
    
    func stop() {
        
        guard let vc = playerViewController else { return }
        
        vc.stop {
            vc.willMoveToParentViewController(nil)
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
