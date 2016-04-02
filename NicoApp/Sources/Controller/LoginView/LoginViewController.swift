//
//  LoginViewController.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/28.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import KeychainAccess

import NicoEntity


class LoginViewController: UIViewController {
    
    private let contentView: LoginContentView = lazy {
        UINib(nibName: "LoginContentView", bundle: nil)
            .instantiateWithOwner(nil, options: nil).first as! LoginContentView
    }
    
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let superview = self.view
        superview.addSubview(contentView)
        contentView.snp_makeConstraints { make in
            make.edges.equalTo(superview)
        }
        
        
        contentView.loginButton.rx_tap
            .doOnNext {
                self.contentView.loginButton.enabled = false
            }
            .flatMap {
                Observable.combineLatest(
                    self.contentView.emailTextField.rx_text,
                    self.contentView.passwordTextField.rx_text
                ) { ($0, $1) }
            }
            .flatMap { (mailaddress, password) -> Observable<Session> in
                let keychain = Keychain(service: "jp.sora0077.NicoApp")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    do {
                        let defaults = NSUserDefaults.standardUserDefaults()
                        guard defaults.stringForKey("mailaddress") == nil else { return }
                        try keychain
                            .accessibility(.WhenPasscodeSetThisDeviceOnly, authenticationPolicy: .UserPresence)
                            .set(password, key: mailaddress)
                        defaults.setObject(mailaddress, forKey: "mailaddress")
                        defaults.synchronize()
                    } catch {
                        print(error)
                    }
                }
                return domain.repository.session.login(mailaddress: mailaddress, password: password)
            }
            .subscribeNext { _ in
                self.contentView.loginButton.enabled = true
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            .addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let keychain = Keychain(service: "jp.sora0077.NicoApp")
        let defaults = NSUserDefaults.standardUserDefaults()
        if let key = defaults.stringForKey("mailaddress") {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                if let password = try? keychain.authenticationPrompt("").get(key) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.contentView.emailTextField.text = key
                        self.contentView.passwordTextField.text = password
                        self.contentView.loginButton.sendActionsForControlEvents(.TouchUpInside)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
