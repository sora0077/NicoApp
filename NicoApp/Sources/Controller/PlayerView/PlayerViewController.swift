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


private var AVPlayerItem_nicovideoId: Int8 = 0
private extension AVPlayerItem {

    var nicovideoId: String? {
        set {
            objc_setAssociatedObject(self, &AVPlayerItem_nicovideoId, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AVPlayerItem_nicovideoId) as? String
        }
    }
    
}

private struct QueueItem {
    
    var nicovideoId: String
    
}

class PlayerViewController: UIViewController {
    
    private let playerController = AVPlayerViewController()
    
    private let disposeBag = DisposeBag()
    
    private var queuePlayer = AVQueuePlayer(items: [])
    
    private var queue: ArraySlice<QueueItem> = []
    
    init(video: Video) {
        super.init(nibName: nil, bundle: nil)
        
        queue.append(QueueItem(nicovideoId: video.id))
        
        playerController.delegate = self
        playerController.player = queuePlayer
        queuePlayer.addObserver(self, forKeyPath: "status", options: [.New, .Old], context: nil)
        queuePlayer.addObserver(self, forKeyPath: "currentItem", options: [.New, .Old], context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        [
            "status",
            "currentItem"
        ].forEach {
            queuePlayer.removeObserver(self, forKeyPath: $0)
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard let keyPath = keyPath else { return }
        
        switch keyPath {
        case "status":
            if queuePlayer.status == .ReadyToPlay {
                queuePlayer.play()
            }
        case "currentItem":
            print(queuePlayer.items().count)
            print(queuePlayer.currentItem)
            updateQueue()
            if queuePlayer.currentItem == nil {
                videoStop()
            }
        default:
            break
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
        
        updateQueue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func append(video: Video) {
        
        queue.append(QueueItem(nicovideoId: video.id))
        updateQueue()
    }
    
    func resume() {
        
        if !queuePlayer.items().isEmpty {
            queuePlayer.play()
        }
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
    
    private func updateQueue() {
        
        if queuePlayer.items().count < 3 && !queue.isEmpty {
            let item = queue[queue.startIndex]
            queue = queue.dropFirst()
            fetch(item)
        }
    }
    
    private func fetch(item: QueueItem) {
        
        let id = item.nicovideoId
        guard let video = domain.repository.video.cache(id) else {
            return
        }
        
        domain.repository.video.watch(video)
            .subscribe(
                onNext: { [weak self] flv in
                    guard let `self` = self else { return }
                    let item = AVPlayerItem(URL: NSURL(string: flv.url)!)
                    item.nicovideoId = id
                    
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
    
    @objc func didEndPlay(notification: NSNotification) {
        
        if let item = notification.object as? AVPlayerItem, id = item.nicovideoId {
            if let video = domain.repository.video.cache(id) {
                _ = try? domain.repository.history.add(video)
            }
        }
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

extension PlayerViewController: AVPlayerViewControllerDelegate {
    
    func playerViewControllerDidStartPictureInPicture(playerViewController: AVPlayerViewController) {
        
        UIView.animateWithDuration(0.3) {
            self.view.alpha = 0
        }
    }
    
    func playerViewControllerWillStopPictureInPicture(playerViewController: AVPlayerViewController) {
        
        UIView.animateWithDuration(0.3) {
            self.view.alpha = 1
        }
    }
    
    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(playerViewController: AVPlayerViewController) -> Bool {
        return true
    }
}
