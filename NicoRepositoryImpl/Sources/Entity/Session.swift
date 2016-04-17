//
//  Session.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/20.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import NicoAPI
import RealmSwift
import Realm
import Himotoki
import RxSwift
import RxAPISchema
import QueryKit
import NicoRepository


final class SessionImpl: Object, Session, Decodable {
    
    dynamic var mail_address: String = ""
    dynamic var user_session: String = ""
    dynamic var user_session_expired: NSDate = NSDate()
    dynamic var user_session_secure: String = ""
    dynamic var user_session_secure_expired: NSDate = NSDate()
    dynamic var nicosid: String = ""
    dynamic var nicosid_expired: NSDate = NSDate()
    dynamic var area: String?
    dynamic var lang: String?
    dynamic var nicohistory: String?
    
    required init(
        user_session: String,
        user_session_expired: NSDate,
        user_session_secure: String,
        user_session_secure_expired: NSDate,
        nicosid: String,
        nicosid_expired: NSDate,
        area: String?,
        lang: String?,
        nicohistory: String?
        ) {
            self.user_session = user_session
            self.user_session_expired = user_session_expired
            self.user_session_secure = user_session_secure
            self.nicosid = nicosid
            self.nicosid_expired = nicosid_expired
            self.area = area
            self.lang = lang
            self.nicohistory = nicohistory
            
            super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(value: AnyObject, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

extension SessionImpl {
    
    override class func primaryKey() -> String? {
        return "mail_address"
    }
}

extension SessionImpl {
    
    static let user_session_expired = Attribute<NSDate>("user_session_expired")
}
