//
//  History.swift
//  NicoApp
//
//  Created by 林達也 on 2016/04/03.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol History {
    
    var listenAt: NSDate { get }
    var video: Video { get }
    
//    init(listenAt: NSDate)
}
