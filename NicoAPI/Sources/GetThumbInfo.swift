//
//  GetThumbInfo.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/14.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import Himotoki
import RxAPISchema

public struct GetThumbInfo<VideoType: Video where VideoType: Decodable, VideoType.DecodedType == VideoType>  {
    
    public let videos: [String]
    
    public init(videos: [String]) {
        self.videos = videos
    }
}


extension GetThumbInfo: NicoAPIRequestToken, JSONSerializer {
    
    public typealias Response = [Video]
    public typealias Expect = [String: AnyObject]
    
    public var method: HTTPMethod {
        return .GET
    }
    
    public var path: String {
        return "https://api.ce.nicovideo.jp/nicoapi/v1/video.array"
    }
    
    public var parameters: [String: AnyObject]? {
        return [
            "v": videos.joinWithSeparator(","),
            "__format": "json"
        ]
    }
    
    public func response(request: NSURLRequest?, response: NSHTTPURLResponse?, object: Expect) throws -> Response {
        
        switch object["nicovideo_video_response"]!["video_info"] {
        case let v as Expect:
            return [try decodeValue(v) as VideoType]
        case let vs as [Expect]:
            return try vs.map {
                try decodeValue($0) as VideoType
            }
        default:
            return []
        }
    }
}
