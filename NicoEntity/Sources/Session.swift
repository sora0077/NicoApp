//
//  Session.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/19.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import Himotoki

public protocol Session {
    
    var user_session: String { get }
    var user_session_expired: NSDate { get }
    var user_session_secure: String { get }
    var user_session_secure_expired: NSDate { get }
    var nicosid: String { get }
    var nicosid_expired: NSDate { get }
    var area: String? { get }
    var lang: String? { get }
    var nicohistory: String? { get }

    init(
        user_session: String,
        user_session_expired: NSDate,
        user_session_secure: String,
        user_session_secure_expired: NSDate,
        nicosid: String,
        nicosid_expired: NSDate,
        area: String?,
        lang: String?,
        nicohistory: String?
    )
}

extension NSDate: Decodable {
    
    public static func decode(e: Extractor) throws -> NSDate {
        return e.rawValue as! NSDate
    }
}

extension Session where Self: Decodable {
    
    public static func decode(e: Extractor) throws -> Self {
        
        return try Self.init(
            user_session: e <| "user_session",
            user_session_expired: e <| "user_session_expired",
            user_session_secure: e <| "user_session_secure",
            user_session_secure_expired: e <| "user_session_secure_expired",
            nicosid: e <| "nicosid",
            nicosid_expired: e <| "nicosid_expired",
            area: e <|? "area",
            lang: e <|? "lang",
            nicohistory: e <|? "nicohistory"
        )
    }
}

