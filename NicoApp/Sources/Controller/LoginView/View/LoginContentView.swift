//
//  LoginView.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/29.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import UIKit
import SnapKit
import JVFloatLabeledTextField

class LoginContentView: UIView {

    let emailTextField = JVFloatLabeledTextField()
    let passwordTextField = JVFloatLabeledTextField()
    
    @IBOutlet private weak var emailContainerView: UIView! {
        didSet {
            let superview = emailContainerView
            superview.addSubview(emailTextField)
            emailTextField.snp_makeConstraints { make in
                make.edges.equalTo(superview).inset(UIEdgeInsets(top: 4, left: 8, bottom: 2, right: 8))
            }
            
            emailTextField.placeholder = "メールアドレスまたは電話番号"
            emailTextField.autocapitalizationType = .None
            emailTextField.autocorrectionType = .No
            emailTextField.keyboardType = .EmailAddress
        }
    }
    @IBOutlet private weak var passwordContainerView: UIView! {
        didSet {
            let superview = passwordContainerView
            superview.addSubview(passwordTextField)
            passwordTextField.snp_makeConstraints { make in
                make.edges.equalTo(superview).inset(UIEdgeInsets(top: 4, left: 8, bottom: 2, right: 8))
            }
            
            passwordTextField.placeholder = "パスワード"
            passwordTextField.secureTextEntry = true
        }
    }
    
    
    @IBOutlet weak var loginButton: UIButton!
}
