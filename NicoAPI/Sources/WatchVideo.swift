//
//  WatchVideo.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/19.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import RxAPISchema
import Himotoki

public struct WatchVideo {
    
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}

extension WatchVideo: NicoAPIRequestToken, DataSerializer {
    
    public typealias Response = ()
    public typealias Expect = NSData
    
    public var path: String {
        return "http://www.nicovideo.jp/watch/\(id)?watch_harmful=1"
    }
    
    public var method: HTTPMethod {
        return .HEAD
    }
    
    public func response(request: NSURLRequest?, response: NSHTTPURLResponse?, object: Expect) throws -> Response {
        
    }
}

