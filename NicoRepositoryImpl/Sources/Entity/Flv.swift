//
//  Flv.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/20.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import NicoAPI
import RealmSwift
import Himotoki
import RxSwift
import RxAPISchema
import NicoRepository


class FlvImpl: Object, Flv, Decodable {
    
    dynamic var thread_id: String = ""
    dynamic var url: String = ""
    dynamic var ms: String = ""
    dynamic var ms_sub: String?
    dynamic var user_id: Int = 0
    dynamic var is_premium: Bool = false
    dynamic var nickname: String = ""
    dynamic var time: Int = 0
    dynamic var done: Bool = false
    dynamic var l: String?
    dynamic var hms: String?
    dynamic var hmsp: String?
    dynamic var hmst: String?
    dynamic var hmstk: String?
    
    required init(
        thread_id: String,
        url: String,
        ms: String,
        ms_sub: String?,
        user_id: Int,
        is_premium: Bool,
        nickname: String,
        time: Int,
        done: Bool,
        l: String?,
        hms: String?,
        hmsp: String?,
        hmst: String?,
        hmstk: String?
        ) {
            self.thread_id = thread_id
            self.url = url
            self.ms = ms
            self.ms_sub = ms_sub
            self.user_id = user_id
            self.is_premium = is_premium
            self.nickname = nickname
            self.time = time
            self.done = done
            self.l = l
            self.hms = hms
            self.hmsp = hmsp
            self.hmst = hmst
            self.hmstk = hmstk
            super.init()
    }
    
    required init() {
        super.init()
    }
}

extension FlvImpl {
    
    override class func primaryKey() -> String? {
        return "thread_id"
    }
}
