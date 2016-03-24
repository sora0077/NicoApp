//
//  GetRanking.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/21.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import RxAPISchema
import Fuzi

public struct GetRanking {
    
    public enum Target: String {
        case Total = "fav"
        case View = "view"
        case Res = "res"
        case Mylist = "mylist"
    }
    
    public enum Period: String {
        case Hourly = "hourly"
        case Daily = "daily"
        case Weekly = "weekly"
        case Monthly = "monthly"
    }
    
    public enum Category: String {
        case All = "all"
        case Music = "music"
        case Ent = "ent"
        case Anime = "anime"
        case Game = "game"
        case Animal = "animal"
        case Science = "science"
        case Other = "other"
    }
    
    public let target: Target
    public let period: Period
    public let category: Category
    
    public init(target: Target = .Total, period: Period, category: Category = .All) {
        self.target = target
        self.period = period
        self.category = category
    }
}

extension GetRanking: NicoAPIRequestToken, XMLSerializer {
    
    public typealias Response = [String]
    public typealias Expect = XMLDocument
    
    public var path: String {
        return "http://www.nicovideo.jp/ranking/\(target.rawValue)/\(period.rawValue)/\(category.rawValue)?rss=2.0"
    }
    
    public var method: HTTPMethod {
        return .GET
    }
    
    public func response(request: NSURLRequest?, response: NSHTTPURLResponse?, object: Expect) throws -> Response {
        
        return object.xpath("//item").map { elem in
            elem.firstChild(xpath: "link")!.stringValue.componentsSeparatedByString("/").last!
        }
    }
}
