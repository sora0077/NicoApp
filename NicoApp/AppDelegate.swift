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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var manager: Manager<WindowLayer> = Manager<WindowLayer>(keyWindow: self.window!)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = EntryPointController()
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

