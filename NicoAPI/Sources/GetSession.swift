//
//  GetSession.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/19.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import RxAPISchema
import Himotoki

public struct GetSession<SessionType: Session where SessionType: Decodable, SessionType.DecodedType == SessionType> {
    
    public let mailaddress: String
    public let password: String
    
    public init(mailaddress: String, password: String) {
        self.mailaddress = mailaddress
        self.password = password
    }
}

extension GetSession: NicoAPIRequestToken, StringSerializer {
    
    public typealias Response = Session
    public typealias Expect =  String
    
    public var path: String {
        return "https://secure.nicovideo.jp/secure/login?site=niconico"
    }
    
    public var method: HTTPMethod {
        return .POST
    }
    
    public var parameters: [String: AnyObject]? {
        return [
            "mail": mailaddress,
            "password": password
        ]
    }
    
    public func response(request: NSURLRequest?, response: NSHTTPURLResponse?, object: Expect) throws -> Response {
        
        guard
            let url = request?.URL,
            let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(url) else
        {
            throw NicoAPIError.ParseError("")
        }
        
        var dict: [String: (value: String, date: NSDate?)] = [:]
        for c in cookies {
            dict[c.name] = (value: c.value, date: c.expiresDate)
        }
        
        let user_session = dict["user_session"]!.value
        let user_session_expired = dict["user_session"]!.date!
        let user_session_secure = dict["user_session_secure"]!.value
        let user_session_secure_expired = dict["user_session_secure"]!.date!
        let nicosid = dict["nicosid"]!.value
        let nicosid_expired = dict["nicosid"]!.date!
        
        var context: [String: AnyObject] = [
            "user_session": user_session,
            "user_session_expired": user_session_expired,
            "user_session_secure": user_session_secure,
            "user_session_secure_expired": user_session_secure_expired,
            "nicosid": nicosid,
            "nicosid_expired": nicosid_expired
        ]
        
        if let area = dict["area"]?.value {
            context["area"] = area
        }
        if let lang = dict["lang"]?.value {
            context["lang"] = lang
        }
        if let nicohistory = dict["nicohistory"]?.value.stringByRemovingPercentEncoding {
            context["nicohistory"] = nicohistory
        }
        
        return try decodeValue(context) as SessionType
    }
}
