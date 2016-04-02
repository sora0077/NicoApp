//
//  PlayerViewController.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/30.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

import RxSwift
import SnapKit

import NicoEntity


class PlayerViewController: UIViewController {
    
    private let playerController = AVPlayerViewController()
    
    private let video: Video
    
    private let disposeBag = DisposeBag()
    
    private var queuePlayer = AVQueuePlayer(items: [])
    
    init(video: Video) {
        self.video = video
        super.init(nibName: nil, bundle: nil)
        
        playerController.player = queuePlayer
        queuePlayer.addObserver(self, forKeyPath: "status", options: [.New, .Old], context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        queuePlayer.removeObserver(self, forKeyPath: "status")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if case ("status"?, .ReadyToPlay) = (keyPath, queuePlayer.status) {
            queuePlayer.play()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let superview = view
        let scale: CGFloat = 1.5
        view.addSubview(playerController.view)
        playerController.view.snp_makeConstraints { make in
            make.edges.equalTo(superview).multipliedBy(scale)
        }
        playerController.view.layer.anchorPoint = CGPoint(x: 0.5 * scale, y: 0.5 * scale)
        playerController.view.transform = CGAffineTransformMakeScale(1/scale, 1/scale)
        addChildViewController(playerController)
        playerController.didMoveToParentViewController(self)
        
        
        fetch(video)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func append(video: Video) {
        
        fetch(video)
    }
    
    func stop(completion: () -> Void) {
        let _stop = {
            self.queuePlayer.removeAllItems()
            self.queuePlayer.pause()
            completion()
        }
        if let vc = self.presentedViewController {
            UIView.animateWithDuration(0.2, animations: {
                self.view.alpha = 0
            })
            vc.dismissViewControllerAnimated(true) {
                _stop()
            }
        } else {
            _stop()
        }
    }
    
    private func fetch(video: Video) {
        
        domain.repository.video.watch(video)
            .subscribe(
                onNext: { [weak self] flv in
                    print(flv)
                    guard let `self` = self else { return }
                    let item = AVPlayerItem(URL: NSURL(string: flv.url)!)
                    
                    NSNotificationCenter.defaultCenter().addObserver(
                        self,
                        selector: #selector(PlayerViewController.didEndPlay),
                        name: AVPlayerItemDidPlayToEndTimeNotification,
                        object: item
                    )
                    
                    self.queuePlayer.insertItem(item, afterItem: nil)
                },
                onError: { error in
                    print(error)
                    videoStop()
                }
            )
            .addDisposableTo(disposeBag)
    }
    
    @objc func didEndPlay() {
        if queuePlayer.items().count == 1 {
            videoStop()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}