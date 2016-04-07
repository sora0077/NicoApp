//
//  AppDelegate.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/14.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//
import UIKit
import NicoDomain
import NicoDomainImpl
import RealmSwift
import RxSwift
import RxAPISchema
import WindowKit

let domain: Domain = DomainImpl(client: Client())
 
enum WindowLayer: Int, WindowLevel {
    case player = 1
    case alert
}

func window(layer: WindowLayer) -> UIWindow {
    return (UIApplication.sharedApplication().delegate as! AppDelegate).manager[layer]
}

func async_after(sec: Double, _ block: () -> Void) {
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(sec * Double(NSEC_PER_SEC)))
    dispatch_after(when, dispatch_get_main_queue(), block)
}

import NicoEntity

private func appDelegate() -> AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
}

func videoPlay(video: Video) {
    
    guard let host = window(.player).rootViewController as? PlayerHostController else {
        window(.player).rootViewController = appDelegate().playerHostController
        return videoPlay(video)
    }
    
    host.play(video)
}

func videoResume() {
    
    guard let host = window(.player).rootViewController as? PlayerHostController else {
        return
    }
    
    host.resume()
}

func videoPause() {
    
}

func videoStop() {
    
    guard let host = window(.player).rootViewController as? PlayerHostController else {
        return
    }
    
    host.stop()
}

import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var manager: Manager<WindowLayer> = Manager<WindowLayer>(keyWindow: self.window!)
    
    private let playerHostController = PlayerHostController()

    private let disposeBag = DisposeBag()
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = EntryPointController()
        window?.makeKeyAndVisible()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        try! session.setActive(true)
        
        domain.repository.history.list().subscribe(
            onNext: { histories in
                if let history = histories.first {
                    print(history.listenAt, history.video)
                }
            }
        ).addDisposableTo(disposeBag)
        
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        videoResume()
    }
    
    private let regex = try! NSRegularExpression(pattern: "(sm|nm|so)?\\d+", options: [])
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        let path = (url.host ?? "") + (url.query ?? "")
        if let _ = regex.firstMatchInString(path, options: [], range: NSMakeRange(0, path.utf16.count)) {
            domain.repository.video.get(path)
                .subscribeNext { video in
                    guard let video = video else { return }
                    videoPlay(video)
                }
                .addDisposableTo(disposeBag)
        }
        
        return false
    }

}

