//
//  WebViewController.swift
//  NicoApp
//
//  Created by 林達也 on 2016/04/11.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import UIKit
import WebKit

import SnapKit


final class WebViewController: UIViewController {
    
    private let config: WKWebViewConfiguration
    private lazy var webView: WKWebView = WKWebView(frame: CGRectZero, configuration: self.config)
    
    private let request: NSURLRequest
    
    init(request: NSURLRequest, config: WKWebViewConfiguration = WKWebViewConfiguration()) {
        self.request = request
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(url: NSURL, config: WKWebViewConfiguration = WKWebViewConfiguration()) {
        self.init(request: NSURLRequest(URL: url), config: config)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let superview = view
        view.addSubview(webView)
        webView.snp_makeConstraints { make in
            make.edges.equalTo(superview)
        }
        
        let request = self.request.mutableCopy() as! NSMutableURLRequest
        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(request.URL!)
        let header = NSHTTPCookie.requestHeaderFieldsWithCookies(cookies ?? [])
        request.allHTTPHeaderFields = header
        
        print(header)
        
        webView.loadRequest(request)
    }
}
