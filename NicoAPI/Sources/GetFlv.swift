
//
//  GetFlv.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/14.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import RxAPISchema
import Himotoki

public struct GetFlv<FlvType: Flv where FlvType: Decodable> {
    
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}

extension GetFlv: NicoAPIRequestToken, StringSerializer {
    
    public typealias Response = Flv
    public typealias Expect = String
    
    public var path: String {
        return "http://www.nicovideo.jp/api/getflv/\(id)"
    }
    
    public var method: HTTPMethod {
        return .GET
    }
    
    public func response(request: NSURLRequest?, response: NSHTTPURLResponse?, object: Expect) throws -> Response {
        
        var dict: [String: String] = [:]
        let str = object.stringByRemovingPercentEncoding!
        let kvs = str.characters.lazy.split("&").map {
            $0.split("=", maxSplit: 1).map(String.init)
        }
        
        for kv in kvs {
            if kv.count == 2 {
                dict[kv[0]] = kv[1]
            }
        }
        
        if "1" == dict["closed"] {
            throw NicoAPIError.ParseError("")
        }
        
        if let e = dict["error"] {
            throw NicoAPIError.ParseError(e)
        }
        
        return try decodeValue(dict) as FlvType
    }
}
