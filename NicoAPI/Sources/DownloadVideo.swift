
//
//  DownloadFlv.swift
//  NicoApp
//
//  Created by 林達也 on 2016/04/13.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import RxAPISchema
import Himotoki

public struct DownloadVideo {
    
    public let url: NSURL
    
    public init(url: NSURL) {
        self.url = url
    }
}

extension DownloadVideo: NicoAPIRequestToken, DataSerializer {
    
    public typealias Response = ()
    public typealias Expect = NSData
    
    public var path: String {
        return url.absoluteString
    }
    
    public var method: HTTPMethod {
        return .GET
    }
    
    public func response(request: NSURLRequest?, response: NSHTTPURLResponse?, object: Expect) throws -> Response {
        
    }
}


