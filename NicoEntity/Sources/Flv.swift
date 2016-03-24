//
//  Flv.swift
//  NicoEntity
//
//  Created by 林達也 on 2016/02/14.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import Himotoki

public protocol Flv {
    
    var thread_id: String { get }
    var url: String { get }
    var ms: String { get }
    var ms_sub: String? { get }
    var user_id: Int { get }
    var is_premium: Bool { get }
    var nickname: String { get }
    var time: Int { get }
    var done: Bool { get }
    var l: String? { get }
    var hms: String? { get }
    var hmsp: String? { get }
    var hmst: String? { get }
    var hmstk: String? { get }
    
    init(
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
    )
}

extension Flv where Self: Decodable {
    
    public static func decode(e: Extractor) throws -> Self {
        
        return try Self.init(
            thread_id: e <| "thread_id",
            url: e <| "url",
            ms: e <| "ms",
            ms_sub: e <|? "ms_sub",
            user_id: e <| "user_id" <- convertInt,
            is_premium: e <| "is_premium" <- convertBool,
            nickname: e <| "nickname",
            time: e <| "time" <- convertInt,
            done: e <| "done" <- convertBool,
            l: e <|? "l",
            hms: e <|? "hms",
            hmsp: e <|? "hmsp",
            hmst: e <|? "hmst",
            hmstk: e <|? "hmstk"
        )
    }
}
