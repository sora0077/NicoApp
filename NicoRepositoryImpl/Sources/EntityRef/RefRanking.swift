//
//  RefRanking.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/23.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import QueryKit

import NicoAPI


class RefRanking: Object {
    
    dynamic var id: String = NSUUID().UUIDString
    dynamic var _category: String = ""
    dynamic var _period: String = ""
    dynamic var _target: String = ""
    dynamic var createAt: NSDate = NSDate()
    
    let items: List<VideoImpl> = List()
}

extension RefRanking {
    
    static let category = Attribute<String>("_category")
    static let period = Attribute<String>("_period")
    static let target = Attribute<String>("_target")
    static let createAt = Attribute<NSDate>("createAt")
}

extension RefRanking {
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
